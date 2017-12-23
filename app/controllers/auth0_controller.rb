class Auth0Controller < ApplicationController
  skip_before_action :authenticate_user!
  def callback
    # This stores all the user information that came from Auth0
    # and the IdP
    session[:userinfo] = request.env['omniauth.auth']
    if session[:userinfo]['info']['email']
      @current_user = User.find_or_create_by(email: [session[:userinfo]['info']['email']])
      if(@current_user)
        sign_in(@current_user)
      end
    end
    redirect_to '/home/index'
    # Redirect to the URL you want after successful auth
  end

  def failure
    # show a failure page or redirect to an error page
    @error_msg = request.params['message']
  end

  def find_user
    puts session[:userinfo]

  end
end
