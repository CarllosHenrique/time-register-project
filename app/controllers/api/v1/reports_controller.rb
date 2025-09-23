# app/controllers/api/v1/reports_controller.rb
class Api::V1::ReportsController < ApplicationController
  before_action :set_report_process, only: [ :status, :download ]

  def status
    render json: {
      process_id: @report_process.uid,
      status: @report_process.status,
      progress: @report_process.progress
    }
  end

  def download
    result = ::Reports::DownloadReport.call(@report_process)

    unless result.ok
      return render json: { error: error_message(result.error) }, status: :unprocessable_content
    end

    send_file result.path,
              type: "text/csv",
              disposition: "attachment",
              filename: result.filename
  end

  private

  def set_report_process
    begin
      @report_process = ReportProcess.find_by!(uid: params[:uid])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Processo de relatório não encontrado" }, status: :not_found
    end
  end

  def error_message(code)
    {
      not_ready:   "Relatório não está pronto",
      unsafe_path: "Caminho de arquivo inválido"
    }[code] || "Não foi possível baixar o relatório"
  end
end
