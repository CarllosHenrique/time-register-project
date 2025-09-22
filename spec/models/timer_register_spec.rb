# spec/models/timer_register_spec.rb
require 'rails_helper'

RSpec.describe TimerRegister, type: :model do
  it "valida clock_out > clock_in" do
    tr = build(:timer_register, clock_in: Time.current, clock_out: Time.current - 1.minute)
    expect(tr).not_to be_valid
  end

  it "garante apenas um aberto por usuário" do
    user = create(:user)
    create(:timer_register, user:, clock_in: Time.current, clock_out: nil)
    dup = build(:timer_register, user:, clock_in: Time.current - 30.minutes, clock_out: nil)
    expect(dup).not_to be_valid
  end
end
