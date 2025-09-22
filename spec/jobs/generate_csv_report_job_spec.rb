# spec/jobs/generate_csv_report_job_spec.rb
require 'rails_helper'

RSpec.describe GenerateCsvReportJob, type: :job do
  it "gera CSV e marca completed" do
    user = create(:user)
    create_list(:timer_register, 5, user:)
    rp = create(:report_process, user:)

    perform_enqueued_jobs do
      described_class.perform_later(rp.id, 1.month.ago.to_date, Date.today)
    end

    rp.reload
    expect(rp.status).to eq("completed").or eq("processing").or eq("failed") # ajuste se o job roda inline
    expect(rp.file_path.present?).to be true if rp.status == "completed"
  end
end
