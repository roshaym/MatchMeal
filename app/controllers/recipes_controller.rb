class RecipesController < ApplicationController
  require "json"
  require "open-uri"

  def method_name

  end

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def search
    ingredients = params[:ingredients]

    api_key = ENV['SPOONACULAR_ACCESS_TOKEN']
    url = URI("https://api.spoonacular.com/recipes/findByIngredients?ingredients=#{ingredients}&number=10&ranking=1&apiKey=#{api_key}")

    response = Net::HTTP.get_response(url)
    if response.is_a?(Net::HTTPSuccess)
      @recipes = JSON.parse(response.body)
    else
      @recipes = []
      flash[:alert] = "Failed to fetch recipes. Please try again later."
    end

    render :index
  end

  def recipe_params
    params.require(:recipe).permit(:ingredients, :name) 
  end
end
