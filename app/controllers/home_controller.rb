class HomeController < ApplicationController
  include ::Secured
  def index
    @user = current_user
    @matches = current_user.matches
  end

  def login

  end
end
