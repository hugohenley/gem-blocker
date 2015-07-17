class CommitsController < ApplicationController

  def show
    @commit = Commit.find(params[:id])
    @previous_commit = @commit.previous
    @next_commit = @commit.next
  end

end
