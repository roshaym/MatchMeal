class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    session.delete(:detected_ingredients)
  end
end
