class UsersController < ApplicationController
  skip_before_action :authenticate_gameplan_user!, only: [:new, :update]
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

    if !GameMode.find_by_user_id(@user.id)
      GameMode.create!(user_id: @user.id)
    end
    sign_in(@user)
    flash[:notice] = "Welcome #{@user.name}, Time to Add Matches. Select the 'Add New Match' to Start"
    redirect '/matches'
  end

  def update
    @user = User.find(update_params[:id])
    if @user.email != update_params[:email]
      response.status = 400
    else
      @user.password = update_params[:password] if update_params[:password]
      @user.name = update_params[:name] if update_params[:name]
      @user.usta_number = update_params[:usta_number] if update_params[:usta_number]
      @user.club_id = update_params[:club_id].to_i if update_params[:club_id]
      @user.city = update_params[:city] if update_params[:city]
      @user.state = update_params[:state] if update_params[:state]
      @user.zipcode = update_params[:zipcode] if update_params[:zipcode]
      @user.save!
      UstaWebService.update_user(@user.usta_number,@user.name,@user)
      if !GameMode.find_by_user_id(@user.id)
        GameMode.create!(user_id: @user.id)
      end
      sign_in(@user)
    end
    render json: {status: 'update'}
  end

  def destroy
    @user = User.find(update_params[:id])
    @user.delete
    render json: {status: 'deleted'}
  end

  private

  def update_params
    params.permit(:id, :email, :name, :password, :usta_number, :club_id, :zipcode, :state, :city)
  end
end