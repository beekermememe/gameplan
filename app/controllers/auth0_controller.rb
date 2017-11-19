class Auth0Controller < ApplicationController
  def callback
    # This stores all the user information that came from Auth0
    # and the IdP
    session[:userinfo] = request.env['omniauth.auth']
    current_user = User.find_or_create_by_email [session[:userinfo]['email']]
    if(current_user)

    else

    end

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
