require 'base64'
require 'openai'
require "open-uri"

class RecipesController < ApplicationController
  def index
    api_key = ENV['SPOONACULAR_ACCESS_TOKEN']

    @ingredients = session[:detected_ingredients]
    if @ingredients.nil?
      flash[:error] = "No ingredients detected yet."
      redirect_to detect_ingredients_recipes_path
    end

    url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=#{@ingredients}&number=10&ranking=1&apiKey=#{api_key}"

    begin
      # Open the URL and parse the JSON response
      @posts = []
      response = URI.parse(url).read
      @posts = JSON.parse(response)
    rescue OpenURI::HTTPError => e
      # Handle errors (e.g., API down, invalid URL)
      @posts = []
      flash[:alert] = "Failed to fetch posts: #{e.message}"
    end

    # @recipes = Recipe.all

  end

  def show
    api_key = ENV['SPOONACULAR_ACCESS_TOKEN']
    recipe_id = params[:id]

    url = "https://api.spoonacular.com/recipes/#{recipe_id}/information?apiKey=#{api_key}"

    begin
      response = URI.parse(url).read
      @recipe = JSON.parse(response)

      # # Ensure defaults if keys are missing
      # @recipe["usedIngredients"] ||= []
      # @recipe["missedIngredients"] ||= []
    rescue OpenURI::HTTPError => e
      flash[:error] = "Unable to fetch recipe details: #{e.message}"
      redirect_to recipes_path
    end
  end

  def detect_ingredients
    # Render the form for uploading an image
  end

  def process_image
    # Check if an image was uploaded
    unless params[:image].present?
      flash[:error] = "Please upload an image"
      return redirect_to detect_ingredients_recipes_path
    end

    # Read the uploaded file
    uploaded_file = params[:image]

    # Encode the image to base64
    base64_image = Base64.encode64(uploaded_file.read)

    # Initialize OpenAI client
    client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY']
    )

    # Send request to OpenAI
    begin
      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            {
              role: "user",
              content: [
                {
                  type: "text",
                  text: "Identify all the ingredients in this image and provide just the ingredients (do not use numbers or symbols) using comma separated values."
                },
                {
                  type: "image_url",
                  image_url: {
                    url: "data:image/jpeg;base64,#{base64_image}"
                  }
                }
              ]
            }
          ]
        }
      )

      # Extract the content from the response
      @ingredients = response.dig("choices", 0, "message", "content")

      # Store ingredients in the session to pass to the next page
      session[:detected_ingredients] = @ingredients

      # Redirect to the detect_ingredients page with the results
      redirect_to detect_ingredients_recipes_path, notice: "Ingredients detected successfully!"
    rescue StandardError => e
      flash[:error] = "Error processing image: #{e.message}"
      redirect_to detect_ingredients_recipes_path
    end
  end

  def generate_recipes
    api_key = ENV['SPOONACULAR_ACCESS_TOKEN']

    @ingredients = session[:detected_ingredients]
    if @ingredients.nil?
      flash[:error] = "No ingredients detected yet."
      redirect_to detect_ingredients_recipes_path
    end

    url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=#{@ingredients}&number=10&ranking=1&apiKey=#{api_key}"

    begin
      # Open the URL and parse the JSON response
      @posts = []
      response = URI.parse(url).read
      @posts = JSON.parse(response)
    rescue OpenURI::HTTPError => e
      # Handle errors (e.g., API down, invalid URL)
      @posts = []
      flash[:alert] = "Failed to fetch posts: #{e.message}"
    end
  end

  private

  def recipe_params
    params.permit(:image)
  end

end
