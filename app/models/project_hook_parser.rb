class ProjectHookParser
  attr_accessor :name, :gitlab_id

  def initialize(params)
    @name = params["name"]
    @gitlab_id = params["id"]
  end

  def to_param!
    ssh, http = self.add_ssh_http_info
    {name: @name, gitproject_id: @gitlab_id, ssh_url_to_repo: ssh, http_url_to_repo: http}
  end

  def add_ssh_http_info
    project_info = GitServer.new(@gitlab_id).project_info(:gitlab)
    return project_info["ssh_url_to_repo"], project_info["http_url_to_repo"]
  end

end