module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?
  end

  def logged_in_using_omniauth?
    unless session[:userinfo].present?
      redirect_to '/auth/auth0'
    end
  end
end