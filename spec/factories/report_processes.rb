# spec/factories/report_processes.rb
FactoryBot.define do
  factory :report_process do
    association :user
    status { "queued" }
    progress { 0 }
  end
end
