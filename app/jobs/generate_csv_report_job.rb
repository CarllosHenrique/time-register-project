# app/jobs/generate_csv_report_job.rb
require "csv"
class GenerateCsvReportJob < ApplicationJob
  queue_as :default

  def perform(report_process_id, start_date, end_date)
    rp = ReportProcess.find(report_process_id)
    rp.update!(status: :processing, started_at: Time.current, progress: 1)

    user = rp.user
    start_dt = Date.parse(start_date.to_s).beginning_of_day
    end_dt   = Date.parse(end_date.to_s).end_of_day

    scope = user.timer_registers.where(clock_in: start_dt..end_dt)

    dir = Rails.root.join("storage", "reports", user.id.to_s)
    FileUtils.mkdir_p(dir)
    path = dir.join("report_#{rp.uid}.csv").to_s

    total = scope.count
    processed = 0

    CSV.open(path, "w") do |csv|
      csv << %w[id user_id clock_in clock_out worked_minutes open]
      scope.find_each(batch_size: 500) do |tr|
        worked = tr.clock_out.present? ? ((tr.clock_out - tr.clock_in) / 60).to_i : nil
        open   = tr.clock_out.nil?
        csv << [ tr.id, tr.user_id, tr.clock_in.iso8601, tr.clock_out&.iso8601, worked, open ]
        processed += 1
        rp.update(progress: ((processed.to_f / [ total, 1 ].max) * 100).to_i) if (processed % 100).zero?
      end
    end

    rp.update!(status: :completed, progress: 100, file_path: path, finished_at: Time.current)
  rescue => e
    rp&.update!(status: :failed, error: "#{e.class}: #{e.message}", finished_at: Time.current)
    raise
  end
end
