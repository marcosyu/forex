class HomeController < ApplicationController

  def index
    redirect_to admin_calculations_path if current_user.present?
  end

end
