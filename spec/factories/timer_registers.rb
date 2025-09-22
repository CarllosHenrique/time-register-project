# spec/factories/timer_registers.rb
FactoryBot.define do
  factory :timer_register do
    association :user
    clock_in  { Time.current - 2.hours }
    clock_out { Time.current - 1.hour }
  end
end
