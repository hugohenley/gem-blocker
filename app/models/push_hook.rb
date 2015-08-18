class PushHook
  attr_reader :title, :author_name, :author_email, :commit_created_at, :git_project_id, :commits

  def initialize params
    @git_project_id = params["project_id"] || params[:project_id]
    @commits = params["commits"] || params[:commits]
  end

  def save!
    project_id = Project.where(gitproject_id: @git_project_id).take.try(:id) || create_project(@git_project_id)
    @commits.each do |commit|
      c = Commit.create(author_name: commit[:author][:name],
                    author_email: commit[:author][:email],
                    project_id: project_id,
                    hash_id: commit[:id],
                    commit_created_at: commit[:timestamp],
                    title: commit[:message])
      GemImporter.new(@git_project_id, c, :gitlab).import
      project = Project.find_by_id project_id
      set_compliance_status project
    end
  end

  private
  def create_project git_project_id
    params = GitServer.new(git_project_id).project_info(:gitlab)
    hook_params = ProjectHookParser.new(params).to_param!
    project = Project.new(hook_params)
    project.id if project.save
  end

  def set_compliance_status project
    return if project.commits.empty?
    used_gems = project.commits.last.used_gems
    used_gems.each do |used_gem|
      next if used_gem.status
      Gemblocker::ALLOWED_TYPES.each do |type|
        locked_gems = Gemblocker.hash_of type
        found = locked_gems.detect { |x| x[used_gem.name] }
        if found && type == "Deny"
          locked_versions = found[used_gem.name].join(", ")
          Status.new(used_gem_id: used_gem.id, lock_type: type, locked_versions: locked_versions).save
        elsif found && !found[used_gem.name].include?(used_gem.version) && (type == "Allow If Present" || type == "Required")
          locked_versions = found[used_gem.name].join(", ")
          Status.new(used_gem_id: used_gem.id, lock_type: type, locked_versions: locked_versions).save
        elsif (!locked_gems.map { |x| x.keys.first }.include? used_gem.name) && type == :required
          Status.new(used_gem_id: used_gem.id, lock_type: "Not Present", locked_versions: locked_versions).save
        end
      end
    end
  end

end