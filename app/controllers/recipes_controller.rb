class RecipesController < ApplicationController
  require "json"
  require "open-uri"

  def method_name

  end

  def index
    @recipes = Recipe.all
    api_key = ENV['SPOONACULAR_ACCESS_TOKEN']
    ingredients = params[:ingredients]
    url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=#{ingredients}&number=10&ranking=1&apiKey=#{api_key}"

    begin
      # Open the URL and parse the JSON response
      response = URI.open(url).read
      @posts = JSON.parse(response)
    rescue OpenURI::HTTPError => e
      # Handle errors (e.g., API down, invalid URL)
      @posts = []
      flash[:alert] = "Failed to fetch posts: #{e.message}"
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end



  # def search
  #   ingredients = params[:ingredients]

  #   api_key = ENV['SPOONACULAR_ACCESS_TOKEN']
  #   url = URI("https://api.spoonacular.com/recipes/findByIngredients?ingredients=#{ingredients}&number=10&ranking=1&apiKey=#{api_key}")

  #   response = Net::HTTP.get_response(url)
  #   if response.is_a?(Net::HTTPSuccess)
  #     @recipes = JSON.parse(response.body)
  #   else
  #     @recipes = []
  #     flash[:alert] = "Failed to fetch recipes. Please try again later."
  #   end

  #   render :index
  # end

  def recipe_params
    params.require(:recipe).permit(:ingredients, :name)
  end
end
