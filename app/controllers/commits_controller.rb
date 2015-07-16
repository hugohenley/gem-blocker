class CommitsController < ApplicationController

  def show
    @commit = Commit.find(params[:id])
  end

end
