require 'base64'
require 'openai'

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
                  text: "Identify all the ingredients in this image. List them clearly and concisely."
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
      ingredients = response.dig("choices", 0, "message", "content")

      # Store ingredients in the session to pass to the next page
      session[:detected_ingredients] = ingredients

      # Redirect to the detect_ingredients page with the results
      redirect_to detect_ingredients_recipes_path, notice: "Ingredients detected successfully!"
    rescue StandardError => e
      flash[:error] = "Error processing image: #{e.message}"
      redirect_to detect_ingredients_recipes_path
    end
  end
end
