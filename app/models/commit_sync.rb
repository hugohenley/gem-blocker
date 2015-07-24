class CommitSync

  def import_commits(git_project_info, server)
    commits = GitServer.new(git_project_info["id"]).project_commits(server)
    return if commits.empty?
    commits.each do |commit|
      next if Commit.already_imported?(commit)
      c = Commit.new
      c.hash_id = commit["id"]
      c.title = commit["title"]
      c.author_name = commit["author_name"]
      c.commit_created_at = commit["created_at"]
      c.project_id = Project.where(gitproject_id: git_project_info["id"], server: server).first.id
      c.save!
      GemImporter.new(git_project_info["id"], c, commits, server).import
    end
  end

end