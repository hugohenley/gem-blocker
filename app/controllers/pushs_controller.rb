class PushsController < ApplicationController

  def create
    hook_params = PushHookParser.new(params)
    @push = Push.new(hook_params)
    if @push.save
      render :nothing => true, :status => :ok
    else
      render :nothing => true, :status => :internal_server_error
    end
  end

end
