class DosesController < ApplicationController
  def new
    @cocktail = Cocktail.find(params[:id])
    @dose = Dose.new
  end

  def create
    @cocktail = Cocktail.find(params[:id])
    @dose.ingredient = cocktail_params[:ingredient]
    @dose.cocktail = cocktail_params[:cocktail]
    raise
  end

  def destroy
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name)
  end
end
