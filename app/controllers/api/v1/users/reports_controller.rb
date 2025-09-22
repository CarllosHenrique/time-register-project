class Api::V1::Users::ReportsController < ApplicationController
  # POST /api/v1/users/:user_id/reports?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
  def create
    user = User.find(params[:user_id])
    start_date = params.require(:start_date)
    end_date   = params.require(:end_date)

    rp = ReportProcess.create!(user:, status: :queued, progress: 0)
    GenerateCsvReportJob.perform_later(rp.id, start_date, end_date)

    render json: { process_id: rp.uid, status: rp.status }, status: :accepted
  end
end
