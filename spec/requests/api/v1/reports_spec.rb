# spec/requests/api/v1/reports_spec.rb
require 'rails_helper'

RSpec.describe "Reports API", type: :request do
  it "dispara relatório e acompanha status" do
    user = create(:user)
    create_list(:timer_register, 3, user:)

    post "/api/v1/users/#{user.id}/reports", params: { start_date: 1.month.ago.to_date, end_date: Date.today }
    expect(response).to have_http_status(:accepted)
    uid = JSON.parse(response.body)["process_id"]

    get "/api/v1/reports/#{uid}/status"
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["process_id"]).to eq(uid)
    expect(%w[queued processing completed failed]).to include(body["status"])
  end
end
