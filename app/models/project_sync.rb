class ProjectSync

  def self.import!
    begin
      GIT_SERVERS.each do |server|
        projects = GitServer.new.all_projects_info(server.to_sym)
        projects.each do |git_project_info|
          unless Project.already_imported?(git_project_info["id"], server)
            #TODO: Refactor this hash to work with other APIs
            p = Project.new
            p.gitproject_id = git_project_info["id"]
            p.name = git_project_info["name"]
            p.description = git_project_info["description"]
            p.ssh_url_to_repo = git_project_info["ssh_url_to_repo"]
            p.http_url_to_repo = git_project_info["http_url_to_repo"]
            p.server = server
            p.save!
          end
        end
      end
    rescue SocketError
      false
    end
  end


end