class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    recipe_id = params[:recipe_id]

    # Check if the recipe already exists in the database
    recipe = Recipe.find_by(id: recipe_id)

    if recipe.nil?
      # Fetch the recipe data from the API if it doesn't exist
      recipe_data = fetch_recipe_from_api(recipe_id)

      # Create a new recipe record
      recipe = Recipe.create(
        id: recipe_id,
        name: recipe_data["title"],
        image: recipe_data["image"],
        description: recipe_data["description"],
        ingredients: recipe_data["extendedIngredients"].map { |ingredient| ingredient["original"] }.join("\n"),
        instructions: recipe_data["analyzedInstructions"].map { |instruction| instruction["steps"].map { |step| step["step"] }.join(" ") }.join("\n"),
        cooking_time: recipe_data["readyInMinutes"],
        rating: recipe_data["spoonacularScore"]
      )
    end

    # Create the favorite entry for the current user
    favorite = current_user.favorites.create(recipe_id: recipe.id)

    # Redirect to the recipe page with success message
    redirect_to recipe_path(recipe.id), notice: 'Recipe added to favorites!'
  end

  private

  # Fetch recipe data from the external API
  def fetch_recipe_from_api(recipe_id)
    api_key = ENV['SPOONACULAR_ACCESS_TOKEN']
    recipe_id = params[:id]

    url = "https://api.spoonacular.com/recipes/#{recipe_id}/information?apiKey=#{api_key}"
    begin
      response = URI.parse(url).read
      @recipe = JSON.parse(response)

    rescue OpenURI::HTTPError => e
      flash[:error] = "Unable to fetch recipe details: #{e.message}"
      redirect_to recipes_path
    end
  end
end
