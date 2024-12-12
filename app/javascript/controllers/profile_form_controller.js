import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "successMessage", "errorMessage"]

  connect() {
    console.log("ProfileForm controller connected!")
  }

  // Handle form submission
  async submitForm(event) {
    event.preventDefault()

    const form = event.target
    const formData = new FormData(form)
    try {
      const response = await fetch(form.action, {
        method: form.method,
        body: formData,
        headers: {
          "Accept": "application/json"  // Expect JSON response
        }
      })

      if (response.ok) {
        // If successful, display the success message
        const data = await response.json()
        this.showSuccessMessage(data.notice)
      } else {
        // If the server returns an error, display the error message
        const errors = await response.json()
        this.showErrorMessage(errors.errors)
      }
    } catch (error) {
      console.error("Error submitting form:", error)
      this.showErrorMessage(["An unexpected error occurred. Please try again."])
    }
  }

  // Show success message
  showSuccessMessage(message) {
    const successMessageElement = this.successMessageTarget
    successMessageElement.innerText = message
    successMessageElement.classList.remove('d-none')
    successMessageElement.classList.add('alert', 'alert-success')
  }

  // Show error message
  showErrorMessage(errors) {
    const errorMessageElement = this.errorMessageTarget
    errorMessageElement.innerHTML = errors.join('<br />')  // Join multiple error messages
    errorMessageElement.classList.remove('d-none')
    errorMessageElement.classList.add('alert', 'alert-danger')
  }
}
