class User < ApplicationRecord
  has_many :searches, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_recipes, through: :favorites, source: :recipe
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one_attached :profile_picture
  
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }, allow_nil: true

  def update_without_password(params)
    params.delete(:password)
    params.delete(:password_confirmation)
    self.assign_attributes(params)
    save(validate: false)
  end
end
