class ProjectHookParser
  attr_accessor :name, :gitlab_id, :path, :path_namespace

  def initialize(params)
    @name = params[:name]
    @gitlab_id = params[:project_id]
    @path = params[:path]
    @path_namespace = params[:path_with_namespace]
  end

  def to_param!
    ssh, http = self.add_ssh_http_info
    {name: @name, id: @gitlab_id, path: @path,
     path_namespace: @path_namespace, ssh_url_to_repo: ssh,
     http_url_to_repo: http}
  end

  def add_ssh_http_info
    project_info = GitlabWS.new(@gitlab_id).project_info
    return project_info["ssh_url_to_repo"], project_info["http_url_to_repo"]
  end

end