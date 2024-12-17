class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  validates :recipe_id, presence: true #add uniquness?
end
