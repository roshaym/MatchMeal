class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end

  def detect_ingredients
    # Render the form for uploading an image
  end

  def analyze_image
    unless params[:image].present?
      flash.now[:error] = "Please upload an image"
      render :detect_ingredients and return
    end
  
    begin
      # Read the uploaded file and encode to base64
      image_file = params[:image]
      base64_image = Base64.encode64(image_file.read)
  
      # Initialize OpenAI client
      client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  
      # Send request to OpenAI
      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            {
              role: "user",
              content: [
                {
                  type: "text",
                  text: "Identify all the ingredients in this image. List them clearly."
                },
                {
                  type: "image_url",
                  image_url: {
                    url: "data:image/jpeg;base64,#{base64_image}"
                  }
                }
              ]
            }
          ],
          max_tokens: 300
        }
      )
  
      # Extract the content from the response
      @ingredients = response.dig("choices", 0, "message", "content")
  
      # Render the same view with updated @ingredients
      render :detect_ingredients
    rescue StandardError => e
      flash.now[:error] = "Error analyzing image: #{e.message}"
      render :detect_ingredients
    end
  end
end