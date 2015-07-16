class ProjectSync

  def self.import!
    begin
      projects = GitlabWS.new.all_projects_info
      projects.each do |git_project_info|
        unless Project.already_imported?(git_project_info)
          p = Project.new
          p.gitlab_id = git_project_info["id"]
          p.name = git_project_info["name"]
          p.description = git_project_info["description"]
          p.ssh_url_to_repo = git_project_info["ssh_url_to_repo"]
          p.http_url_to_repo = git_project_info["http_url_to_repo"]
          p.save!
        end
        CommitSync.import_commits(git_project_info)
      end
    rescue SocketError
      false
    end
  end


end