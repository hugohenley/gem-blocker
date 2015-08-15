class PushHook
  attr_reader :title, :author_name, :author_email, :commit_created_at, :git_project_id, :commits

  def initialize params
    @git_project_id = params["project_id"]
    @commits = params["commits"]
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
    end
  end

  private
  def create_project git_project_id
    params = GitServer.new(git_project_id).project_info(:gitlab)
    hook_params = ProjectHookParser.new(params).to_param!
    project = Project.new(hook_params)
    project.id if project.save
  end

end