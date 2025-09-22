# spec/requests/api/v1/users_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  it "POST /api/v1/users cria usuário" do
    post "/api/v1/users", params: { user: { name: "Ana", email: "ana@example.com" } }
    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    expect(body["id"]).to be_present
    expect(body["email"]).to eq("ana@example.com")
  end

  it "GET /api/v1/users lista usuários" do
    create(:user)
    get "/api/v1/users"
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to be_an(Array)
  end

  it "GET /api/v1/users/:id retorna um usuário" do
    u = create(:user)
    get "/api/v1/users/#{u.id}"
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["id"]).to eq(u.id)
  end

  it "PUT /api/v1/users/:id atualiza usuário" do
    u = create(:user, name: "Velho")
    put "/api/v1/users/#{u.id}", params: { user: { name: "Novo" } }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["name"]).to eq("Novo")
  end

  it "DELETE /api/v1/users/:id remove usuário" do
    u = create(:user)
    delete "/api/v1/users/#{u.id}"
    expect(response).to have_http_status(:no_content)
    expect(User.exists?(u.id)).to be false
  end

  it "retorna 422 no create quando inválido" do
    post "/api/v1/users", params: { user: { name: "", email: "invalido" } }
    expect(response).to have_http_status(:unprocessable_content)
    expect(JSON.parse(response.body)["errors"]).to be_present
  end

  it "retorna 422 no update quando inválido" do
    u = create(:user)
    put "/api/v1/users/#{u.id}", params: { user: { email: "" } }
    expect(response).to have_http_status(:unprocessable_content)
  end
end
