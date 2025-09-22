class User < ApplicationRecord
  has_many :timer_registers, dependent: :destroy

  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
