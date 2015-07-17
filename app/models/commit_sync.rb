class CommitSync

  def self.import_commits(git_project_info)
    commits = GitlabWS.new(git_project_info["id"]).project_commits
    return if commits.empty?
    commits.each do |commit|
      next if Commit.already_imported?(commit)
      c = Commit.new
      c.hash_id = commit["id"]
      c.title = commit["title"]
      c.author_name = commit["author_name"]
      c.commit_created_at = commit["created_at"]
      c.project_id = Project.find_by_gitlab_id(git_project_info["id"]).id
      c.save!
      GemImporter.new(git_project_info["id"], c, commits).import
    end
  end

end