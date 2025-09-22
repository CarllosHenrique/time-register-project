# spec/requests/api/v1/timer_registers_spec.rb
require 'rails_helper'

RSpec.describe "TimerRegisters API", type: :request do
  it "cria registro e valida regras" do
    user = create(:user)

    post "/api/v1/timer_registers", params: { timer_register: { user_id: user.id, clock_in: Time.current } }
    expect(response).to have_http_status(:created)

    post "/api/v1/timer_registers", params: { timer_register: { user_id: user.id, clock_in: Time.current } }
    expect(response).to have_http_status(:unprocessable_content)
  end
end
