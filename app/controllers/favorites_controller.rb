class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe, only: [:create, :destroy]

  def index
    @favorites = current_user.favorites.includes(:recipe)
  end

  def create
    favorite = current_user.favorites.new(recipe: @recipe)

    if favorite.save
      redirect_to @recipe, notice: 'Recipe was added to your favorites.'
    else
      redirect_to @recipe, alert: 'Unable to add to favorites.'
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(recipe: @recipe)

    if favorite&.destroy
      redirect_to @recipe, notice: 'Recipe was removed from your favorites.'
    else
      redirect_to @recipe, alert: 'Unable to remove from favorites.'
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end
