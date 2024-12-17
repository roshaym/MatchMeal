import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "preview" ]
  
  preview(event) {
    const input = event.target
    const previewElement = this.previewTarget
    
    if (input.files && input.files[0]) {
      const reader = new FileReader()
      
      reader.onload = (e) => {
        previewElement.src = e.target.result
        previewElement.style.display = 'block'
      }
      
      reader.readAsDataURL(input.files[0])
    } else {
      previewElement.style.display = 'none'
    }
  }
}