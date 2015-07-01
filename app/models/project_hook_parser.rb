class ProjectHookParser
  attr_accessor :name, :id, :path, :path_namespace

  def initialize(params)
    @name = params[:name]
    @id = params[:id]
    @path = params[:path]
    @path_namespace = params[:path_with_namespace]
  end

  def ssh_http_info
    
  end

end