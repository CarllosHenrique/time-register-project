# app/services/reports/download_report.rb
module Reports
  class DownloadReport
    Result = Struct.new(:ok, :path, :filename, :error, keyword_init: true)

    def self.call(report_process) = new(report_process).call

    def initialize(report_process)
      @rp = report_process
    end

    def call
      return Result.new(error: :not_ready) unless ready?
      return Result.new(error: :unsafe_path) unless safe_path?(file_path)

      Result.new(ok: true, path: file_path, filename: File.basename(file_path))
    end

    private

    def ready?
      @rp&.status_completed? && file_path.present? && File.exist?(file_path)
    end

    def file_path
      @rp.file_path
    end

    def safe_path?(path)
      base = Rails.root.join("storage", "reports", @rp.user_id.to_s).to_s
      expanded_file = File.expand_path(path.to_s)
      expanded_base = File.expand_path(base)
      expanded_file.start_with?(expanded_base + File::SEPARATOR)
    end
  end
end
