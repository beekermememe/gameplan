class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_gameplan_user!

  def authenticate_gameplan_user!
    if params[:user] && params[:user][:email]
      if User.find_by_email( params[:user][:email].downcase)
        authenticate_user!
      else
        @current_user = User.create(email: params[:user][:email].downcase)
        sign_in(@current_user)
        flash[:notice] = "Welcome to Gameplans! Please fill in you profile to continue"
        redirect_to "/users/new?id=#{@current_user.id}"
      end
    else
      authenticate_user!
    end
  end
end
