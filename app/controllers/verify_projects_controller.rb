class VerifyProjectsController < ApplicationController

  def index
    @projects = NonComplianceProjects.new.list
  end

end
