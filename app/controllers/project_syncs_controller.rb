class ProjectSyncsController < ApplicationController

  def create
    if Sync.new.import
      redirect_to projects_path, notice: "The projects were imported with success"
    else
      redirect_to projects_path, error: "Try again."
    end
  end

end
