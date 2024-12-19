import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 1000) // 1000 milliseconds = 1 second
  }

  dismiss() {
    this.element.classList.remove('show')
    setTimeout(() => {
      this.element.remove()
    }, 150) // Allow fade out animation to complete
  }
}
