// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

import RecipesController from './controllers/recipes_controller.js'
Stimulus.register('recipes', RecipesController)
