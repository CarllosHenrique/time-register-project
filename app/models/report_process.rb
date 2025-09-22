class ReportProcess < ApplicationRecord
  belongs_to :user

  enum :status, {
    queued: "queued",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }, prefix: true

  before_validation :ensure_uid, on: :create

  validates :uid, presence: true, uniqueness: true
  validates :progress, numericality: { in: 0..100 }

  private

  def ensure_uid
    self.uid ||= SecureRandom.uuid
  end
end
