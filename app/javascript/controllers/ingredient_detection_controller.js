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

  // New method to remove an ingredient
  removeIngredient(event) {
    const ingredient = event.currentTarget.dataset.ingredient
    const index = event.currentTarget.dataset.index

    // Remove the ingredient from the list
    const listItem = event.currentTarget.closest('.list-group-item')
    listItem.remove()

    // Update the session or perform any necessary backend logic
    this.updateDetectedIngredients()

    // Recheck generate button state
    this.checkGenerateButtonState()
  }

  updateDetectedIngredients() {
    // This method would typically involve an AJAX call to update the session
    // For now, we'll just update the local session data
    const remainingIngredients = Array.from(
      this.element.querySelectorAll('input[name="selected_ingredients[]"]')
    ).map(input => input.value).join(',')

    // You might want to add an AJAX call here to update the session on the server
    // For example:
    // fetch('/update_detected_ingredients', {
    //   method: 'POST',
    //   body: JSON.stringify({ ingredients: remainingIngredients }),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    //   }
    // })
  }
}
