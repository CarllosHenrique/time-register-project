# spec/requests/users_spec.rb
require "rails_helper"

RSpec.describe "Users API", type: :request do
  it "cria e lista usuário" do
    post "/api/v1/users", params: { user: { name: "Ana", email: "ana@ex.com" } }
    expect(response).to have_http_status(:created)

    get "/api/v1/users"
    expect(JSON.parse(response.body).size).to be >= 1
  end
end
