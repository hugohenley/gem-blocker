class CommitSync

  def import_commits(gitproject_id, server)
    commits = GitServer.new(gitproject_id).project_commits(server)
    return if commits.empty?
    commits.each do |commit|
      next if Commit.already_imported?(commit)
      c = Commit.new
      c.hash_id = commit["id"]
      c.title = commit["title"]
      c.author_name = commit["author_name"]
      c.commit_created_at = commit["created_at"]
      c.project_id = Project.where(gitproject_id: gitproject_id, server: server).first.id
      c.save!
      GemImporter.new(gitproject_id, c, commits, server).import
    end
  end

end