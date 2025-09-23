# spec/services/reports/download_report_spec.rb
require "rails_helper"

RSpec.describe Reports::DownloadReport do
  let(:user) { create(:user) }
  let(:rp)   { create(:report_process, user:, status: "completed", progress: 100) }

  it "retorna ok com caminho válido quando pronto" do
    dir = Rails.root.join("storage", "reports", user.id.to_s)
    FileUtils.mkdir_p(dir)
    file = dir.join("report_test.csv").to_s
    File.write(file, "id,user_id,clock_in,clock_out\n")

    rp.update!(file_path: file)

    result = described_class.call(rp)
    expect(result.ok).to be true
    expect(result.path).to eq(file)
    expect(result.filename).to eq("report_test.csv")
  end

  it "retorna not_ready quando não estiver pronto" do
    result = described_class.call(rp) # sem file_path
    expect(result.ok).not_to be true
    expect(result.error).to eq(:not_ready)
  end

  it "bloqueia caminho fora da pasta do usuário" do
    outside = Rails.root.join("tmp", "evil.csv").to_s
    File.write(outside, "x")
    rp.update!(file_path: outside)

    result = described_class.call(rp)
    expect(result.ok).not_to be true
    expect(result.error).to eq(:unsafe_path)
  end
end
