class Sync

  def import
    import_projects
    import_commits
    import_gems
  end

  def count_projects
    count = 0
    GIT_SERVERS.each do |server|
      count += GitServer.new.all_projects_info(server.to_sym).count
    end
    count
  end

  def count_commits
    commits = 0
    Project.all.each do |project|
      commits += GitServer.new(project.gitproject_id).project_commits(project.server).count
    end
    commits
  end

  def import_projects
    ProjectSync.import!
  end

  def import_commits
    Project.all.each do |project|
      $progress.increment
      CommitSync.new.import_commits(project.gitproject_id, project.server)
    end
  end

  def import_gems
    Commit.all.each do |commit|
      $progress.increment
      project_id = commit.gitproject_id
      #commits = GitServer.new(project_id).project_commits(commit.commit_server)
      #GemImporter.new(project_id, commit, commits, commit.commit_server).import
      GemImporter.new(project_id, commit, commit.commit_server).import
    end
  end

  def set_compliance_status
    Project.all.each do |project|
      next if project.commits.empty?
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
          elsif (!locked_gems.map {|x| x.keys.first}.include? used_gem.name) && type == :required
            Status.new(used_gem_id: used_gem.id, lock_type: "Not Present", locked_versions: locked_versions).save
          end
        end
      end
    end
  end

end