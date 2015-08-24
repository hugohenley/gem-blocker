class VerifyProjectsController < ApplicationController

  def index
    @projects = NonComplianceProjects.new.list
  end

  def status
    project = Project.where(http_url_to_repo: params[:url]).take
    if project.is_compliance?
      render nothing: true, status: :ok
    else
      render nothing: true, status: :forbidden
    end
  end

end
