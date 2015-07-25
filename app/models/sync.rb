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
      commits = GitServer.new(project_id).project_commits(commit.commit_server)
      GemImporter.new(project_id, commit, commits, commit.commit_server).import
    end
  end

end