# app/controllers/api/v1/reports_controller.rb
class Api::V1::ReportsController < ApplicationController
  def status
    rp = ReportProcess.find_by!(uid: params[:uid])
    render json: {
      process_id: rp.uid,
      status: rp.status,
      progress: rp.progress
    }
  end

  def download
    rp = ReportProcess.find_by!(uid: params[:uid])
    return render json: { error: "Relatório não está pronto" },
                  status: :unprocessable_content unless rp.status_completed? && rp.file_path && File.exist?(rp.file_path)

    send_file rp.file_path, type: "text/csv", disposition: "attachment", filename: File.basename(rp.file_path)
  end
end
