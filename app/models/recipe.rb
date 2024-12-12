class Recipe < ApplicationRecord
  has_one_attached :stored_image
  has_many :favorites, dependent: :destroy
  validates :name, presence: true
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validates :search_id, presence: true
  validates :name, :image, :rating, presence: true
end
