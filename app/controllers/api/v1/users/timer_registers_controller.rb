class Api::V1::Users::TimerRegistersController < ApplicationController
  def index
    user = User.find(params[:user_id])
    render json: user.timer_registers.order(clock_in: :desc)
  end
end
