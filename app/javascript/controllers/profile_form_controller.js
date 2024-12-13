import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["form", "successMessage", "errorMessage", "fileInput", "imagePreview"];

  connect() {
    console.log("ProfileForm controller connected!");
  }

  async submitForm(event) {
    event.preventDefault();  // Prevent the default form submission

    const form = event.target;
    const formData = new FormData(form);

    try {
      const response = await fetch(form.action, {
        method: form.method,
        body: formData,
        headers: {
          "Accept": "application/json",  // Expecting a JSON response
        }
      });

      if (response.ok) {
        const data = await response.json();

        if (data.redirect_to) {
          // Redirect to the URL returned by the server (user profile page)
          window.location.href = data.redirect_to;
        } else {
          // If no redirect URL, show a success message
          this.showSuccessMessage(data.notice);
        }
      } else {
        // Handle validation errors if the response isn't successful
        const errors = await response.json();
        this.showErrorMessage(errors.errors);
      }
    } catch (error) {
      console.error("Error submitting form:", error);
      this.showErrorMessage(["An unexpected error occurred. Please try again."]);
    }
  }

  showSuccessMessage(message) {
    const successMessageElement = this.successMessageTarget;
    successMessageElement.innerText = message;
    successMessageElement.classList.remove('d-none');
    successMessageElement.classList.add('alert', 'alert-success');
  }

  showErrorMessage(errors) {
    const errorMessageElement = this.errorMessageTarget;
    errorMessageElement.innerHTML = errors.join('<br />');
    errorMessageElement.classList.remove('d-none');
    errorMessageElement.classList.add('alert', 'alert-danger');
  }

  updateImagePreview(event) {
    const file = event.target.files[0];
    const preview = this.imagePreviewTarget;

    if (file) {
      const reader = new FileReader();

      reader.onload = (e) => {
        preview.src = e.target.result;
        preview.style.display = "block";
      };

      reader.readAsDataURL(file);
    } else {
      preview.style.display = "none";
    }
  }
}
