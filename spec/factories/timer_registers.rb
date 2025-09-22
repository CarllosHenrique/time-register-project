FactoryBot.define do
  factory :timer_register do
    user { nil }
    clock_in { "2025-09-22 10:43:00" }
    clock_out { "2025-09-22 10:43:00" }
  end
end
