class PushsController < ApplicationController

  def create
    hook_params = PushHookParser.new(params)
    @commit = Push.new(hook_params)
    if @commit.save
      redirect_to projects_path, notice: 'Projecto criado com sucesso!'
    else
      render :new
    end
  end

end
