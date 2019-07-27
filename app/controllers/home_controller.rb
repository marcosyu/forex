class HomeController < ApplicationController

  def index
    redirect_to admin_favorite_exchange_rates_path if current_user.present?
  end

end
