class AddSearchIdToRecipe < ActiveRecord::Migration[7.1]
  def change
    add_reference :recipes, :search, null: false, foreign_key: true
  end
end
