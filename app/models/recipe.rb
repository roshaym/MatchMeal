class Recipe < ApplicationRecord
  has_one_attached :stored_image
  has_many :favorites, dependent: :destroy
  has_many :users_who_favorited, through: :favorites, source: :user
  has_many :favorited_by, through: :favorites, source: :user
  validates :name, presence: true
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validates :search_id, presence: true
end
