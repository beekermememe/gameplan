class UsersController < ApplicationController
  skip_before_action :authenticate_gameplan_user!, only: [:new]
  def show
    @user = current_user
  end

  def new
    @user = User.find(params[:id])
  end

  def verify
    @user = User.find(params[:id])
    @user.password = params[:password]
    @user.name = params[:name]
    @user.save!
    sign_in(@user)
    flash[:notice] = "Welcome #{@user.name}, Time to Add Matches. Select the 'Add New Match' to Start"
    redirect '/home/index'
  end
end