class TimerRegister < ApplicationRecord
  belongs_to :user

  validates :clock_in, presence: true
  validate  :clock_out_after_clock_in
  validate  :only_one_open_register_per_user, on: :create

  scope :open_registers, -> { where(clock_out: nil) }

  private

  def clock_out_after_clock_in
    return if clock_out.blank? || clock_in.blank?
    errors.add(:clock_out, "deve ser posterior ao clock_in") if clock_out <= clock_in
  end

  def only_one_open_register_per_user
    return if clock_out.present?
    if self.class.where(user_id: user_id, clock_out: nil).exists?
      errors.add(:base, "usuário já possui registro aberto")
    end
  end
end
