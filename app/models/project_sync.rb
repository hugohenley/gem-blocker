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
    end
  end

  def self.already_imported?(project)
    Project.where(gitlab_id: project["id"]).any?
  end
end