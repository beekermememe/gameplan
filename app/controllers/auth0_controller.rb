class Auth0Controller < ApplicationController
  skip_before_action :authenticate_gameplan_user!
  def callback
    # This stores all the user information that came from Auth0
    # and the IdP
    session[:userinfo] = request.env['omniauth.auth']
    if session[:userinfo]['info']['email']
      @current_user = User.find_by_email([session[:userinfo]['info']['email'].downcase])
      if(@current_user)
        sign_in(@current_user)
        redirect_to '/noticeboard'
      else
        @current_user = User.create(email: [session[:userinfo]['info']['email'].downcase])
        if @current_user
          sign_in(@current_user)
          flash[:notice] = "Welcome to Gameplans! Please fill in you profile to continue"
          redirect_to "/users/new?id=#{@current_user.id}"
        end
      end
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
