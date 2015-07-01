class ProjectSync

  def self.import!
    projects = GitlabWS.new.all_projects_info
    projects.each do |project|
      unless ProjectSync.already_imported?(project)
        p = Project.new
        p.gitlab_id = project["id"]
        p.name = project["name"]
        p.description = project["description"]
        p.ssh_url_to_repo = project["ssh_url_to_repo"]
        p.http_url_to_repo = project["http_url_to_repo"]
        p.save!
      end
      ProjectSync.import_commits(project)
    end
  end

  def self.import_commits(project)
    commits = GitlabWS.new(project["id"]).project_commits
    commits.each do |commit|
      c = Commit.new
      c.hash_id = commit["id"]
      c.title = commit["title"]
      c.author_name = commit["author_name"]
      c.commit_created_at = commit["created_at"]
      c.project_id = Project.find_by_gitlab_id(project["id"]).id
      c.save!
    end
  end

  def self.already_imported?(project)
    Project.where(gitlab_id: project["id"]).any?
  end
end