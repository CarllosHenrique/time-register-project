require "rails_helper"

RSpec.describe "Api::V1::ReportsController", type: :request do
  describe "GET /api/v1/reports/:uid/status" do
    it "retorna status/progress quando o processo existe" do
      rp = create(:report_process, status: "processing", progress: 37)
      get "/api/v1/reports/#{rp.uid}/status"
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["process_id"]).to eq(rp.uid)
      expect(body["status"]).to eq("processing")
      expect(body["progress"]).to eq(37)
    end

    it "retorna 404 quando o uid não existe" do
      get "/api/v1/reports/nao-existe/status"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /api/v1/reports/:uid/download" do
    it "retorna 422 quando ainda não está pronto" do
      rp = create(:report_process, status: "processing", progress: 50, file_path: nil)
      get "/api/v1/reports/#{rp.uid}/download"
      expect(response).to have_http_status(:unprocessable_content)
      body = JSON.parse(response.body)
      expect(body["error"]).to match(/não está pronto/i)
    end

    it "envia o arquivo quando completed e file_path existe" do
      user = create(:user)

      dir  = Rails.root.join("storage", "reports", user.id.to_s)
      FileUtils.mkdir_p(dir)
      path = dir.join("ready_report.csv").to_s

      File.write(path, "id,user_id,clock_in,clock_out,worked_minutes,open\n")

      rp = create(:report_process,
                  user: user,
                  status: "completed",
                  progress: 100,
                  file_path: path)

      get "/api/v1/reports/#{rp.uid}/download"

      expect(response).to have_http_status(:ok)

      expect(response.headers["Content-Type"]).to include("text/csv")

      expect(response.headers["Content-Disposition"]).to include("attachment")
      expect(response.headers["Content-Disposition"]).to include("ready_report.csv")

      expect(response.body).to include("id,user_id,clock_in,clock_out,worked_minutes,open")
    ensure
      FileUtils.rm_f(path) if defined?(path)
    end
  end
end
