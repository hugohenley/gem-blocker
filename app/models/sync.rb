class Sync

  def import
    import_projects
    import_commit
  end

  def import_projects
    ProjectSync.import!
  end

  def import_commit
    Project.all.each do |project|
      CommitSync.new.import_commits(project.gitproject_id, project.server)
    end
  end

  def import_gems
    Commit.all.each do |commit|
      #GemImporter.new(commit.project.gitproject_id, commit, commits, commit.project.server).import
    end
  end

end