class ProjectsController < ApplicationController

  def index
    @projects = Project.includes(:commits).order("commits.commit_created_at DESC").group(:name)
  end
  
  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    hook_params = ProjectHookParser.new(params).to_param!
    @project = Project.new(hook_params)
    if @project.save
      render :nothing => true, :status => :ok
    else
      render :nothing => true, :status => :internal_server_error
    end
  end

  private
  def project_params
    #params.require(:gemblocker).permit(:gem, :verification_type, blockedversions_attributes: [:id, :number, :_destroy])
  end


end
