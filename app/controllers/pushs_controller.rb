class PushsController < ApplicationController

  def create
    hook_params = PushHookParser.new(params)
    @commit = Push.new(hook_params)
    if @commit.save
      render :nothing => true, :status => :ok
    else
      render :nothing => true, :status => :internal_server_error
    end
  end

end
