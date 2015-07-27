class GemblockersController < ApplicationController

  def index
    @gemblockers = Gemblocker.all
  end

  def new
    @gemblocker = Gemblocker.new
  end


  def create
    @gemblocker = Gemblocker.new(gemblocker_params)
    if @gemblocker.save
      redirect_to gemblockers_path, notice: "Gem blocked with success!"
    else
      render :new, error: "Something went wrong, please try again."
    end
  end
  
  def edit
    @gemblocker = Gemblocker.find(params[:id])
  end

  def update
    @gemblocker = Gemblocker.find(params[:id])
    if @gemblocker.update(gemblocker_params)
      redirect_to gemblockers_path, notice: "Gem updated!"
    else
      render :new, error: "Something went wrong, please try again."
    end
  end

  def destroy
    @gemblocker = Gemblocker.find(params[:id])
    if @gemblocker.delete
      redirect_to gemblockers_path, notice: "Gem delete with success!"
    else
      redirect_to gemblockers_path, error: "Something went wrong, please try again."
    end
  end


  private
  def gemblocker_params
    params.require(:gemblocker).permit(:gem, :version, :verification_type)
  end

end
