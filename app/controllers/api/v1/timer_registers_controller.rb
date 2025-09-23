# app/controllers/api/v1/timer_registers_controller.rb
class Api::V1::TimerRegistersController < ApplicationController
  before_action :set_tr, only: %i[show update destroy]

  def index
    render json: TimerRegister.includes(:user).order(created_at: :desc)
  end

  def show
    render json: @tr
  end

  def create
    tr = TimerRegister.new(tr_params)
    if tr.save
      render json: tr, status: :created
    else
      render json: { errors: tr.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    if @tr.update(tr_params)
      render json: @tr, status: :ok
    else
      render json: { errors: @tr.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @tr.destroy
    head :no_content
  end

  private

  def set_tr
    begin
      @tr = TimerRegister.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Registro de ponto não encontrado" }, status: :not_found
    end
  end

  def tr_params
    params.require(:timer_register).permit(:user_id, :clock_in, :clock_out)
  end
end
