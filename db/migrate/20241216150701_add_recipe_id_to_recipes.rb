class AddRecipeIdToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :recipe_id, :integer
  end
end
