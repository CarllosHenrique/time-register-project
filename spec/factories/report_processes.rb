FactoryBot.define do
  factory :report_process do
    uid { "MyString" }
    user { nil }
    status { "MyString" }
    progress { 1 }
    file_path { "MyString" }
    started_at { "2025-09-22 10:38:29" }
    finished_at { "2025-09-22 10:38:29" }
    error { "MyText" }
  end
end
