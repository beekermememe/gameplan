class OpponentsController < ApplicationController
  def show
    @opponent = User.find(show_params[:id])
    render layout: false
  end

  private

  def show_params
    params.permit(:id)
  end
end