import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["input", "results"]

  fetchRecipes(query) {
    fetch(`https://api.spoonacular.com/recipes/findByIngredients?ingredients=${this.inputTarget.value}&number=10&ranking=1&apiKey=${window.SPOONACULAR_ACCESS_TOKEN}`)
      .then(response => response.json())
      .then(data => this.insertRecipes(data))
  }

  insertRecipes(data) {
    data.forEach((result) => {
      const recipeTag = `<li>
        <img src="${result.image}" alt="${result.title}" class="img-fluid">
      </li>`;
      this.resultsTarget.insertAdjacentHTML("afterend", recipeTag);
    });
  }

  search(event) {
    event.preventDefault()
    this.resultsTarget.innerHTML = ""
    this.fetchRecipes(this.inputTarget.value)
  }
}
