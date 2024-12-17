import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "imageUpload", "detectButton", "ingredientCheckbox", "generateButton" ]

  connect() {
    this.checkButtonStates()
    this.checkGenerateButtonState()
  }

  checkButtonStates() {
    // Disable detect button if no image is selected
    if (this.hasImageUploadTarget) {
      this.detectButtonTarget.disabled = this.imageUploadTarget.files.length === 0
    }
  }

  imageSelected(event) {
    // Enable/disable detect ingredients button based on image selection
    this.detectButtonTarget.disabled = event.target.files.length === 0
  }

  // New method to handle checkbox interactions
  ingredientCheckboxChanged() {
    this.checkGenerateButtonState()
  }

  checkGenerateButtonState() {
    // Disable generate button if no ingredients are checked
    if (this.hasGenerateButtonTarget) {
      const checkedIngredients = this.ingredientCheckboxTargets.filter(checkbox => checkbox.checked)
      this.generateButtonTarget.disabled = checkedIngredients.length === 0
    }
  }
}
