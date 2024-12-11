import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["input", "results"]
  search() {
    fetch(`https://api.spoonacular.com/recipes/findByIngredients?ingredients=${this.inputTarget.value}&number=10?s=&apikey=07cf60ef5c3249278a2683f2e07cce53`)
    .then(response => response.json())
    .then((data) => {
      console.log(data)
  });
}
}
