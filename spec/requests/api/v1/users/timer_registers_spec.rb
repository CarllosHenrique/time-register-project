require "rails_helper"

RSpec.describe "Api::V1::TimerRegistersController", type: :request do
  let(:user) { create(:user) }

  describe "GET /api/v1/timer_registers" do
    it "lista em ordem desc por created_at" do
      t1 = create(:timer_register, user:, clock_in: 3.hours.ago, clock_out: 2.hours.ago, created_at: 2.hours.ago)
      t2 = create(:timer_register, user:, clock_in: 1.hour.ago,  clock_out: 30.minutes.ago, created_at: 1.hour.ago)
      get "/api/v1/timer_registers"
      expect(response).to have_http_status(:ok)
      ids = JSON.parse(response.body).map { |h| h["id"] }
      expect(ids.first).to eq(t2.id)
      expect(ids.last).to eq(t1.id)
    end
  end

  describe "GET /api/v1/timer_registers/:id" do
    it "mostra um registro" do
      tr = create(:timer_register, user:)
      get "/api/v1/timer_registers/#{tr.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(tr.id)
    end
  end

  describe "POST /api/v1/timer_registers" do
    it "cria (201) quando válido" do
      post "/api/v1/timer_registers", params: { timer_register: { user_id: user.id, clock_in: Time.current } }
      expect(response).to have_http_status(:created)
    end

    it "retorna 422 se já houver aberto para o usuário" do
      create(:timer_register, user:, clock_in: Time.current, clock_out: nil)
      post "/api/v1/timer_registers", params: { timer_register: { user_id: user.id, clock_in: Time.current } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)["errors"].join).to match(/já possui registro aberto/i)
    end

    it "retorna 400 se payload não tiver a chave timer_register" do
      post "/api/v1/timer_registers", params: { foo: { user_id: user.id } }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "PUT /api/v1/timer_registers/:id" do
    it "atualiza (200) quando válido" do
      tr = create(:timer_register, user:, clock_in: Time.current - 2.hours, clock_out: nil)
      put "/api/v1/timer_registers/#{tr.id}", params: { timer_register: { clock_out: Time.current } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["clock_out"]).to be_present
    end

    it "retorna 422 quando clock_out <= clock_in" do
      tr = create(:timer_register, user:, clock_in: Time.current, clock_out: nil)
      put "/api/v1/timer_registers/#{tr.id}", params: { timer_register: { clock_out: tr.clock_in - 1.minute } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)["errors"].join).to match(/posterior ao clock_in/i)
    end
  end

  describe "DELETE /api/v1/timer_registers/:id" do
    it "deleta e retorna 204" do
      tr = create(:timer_register, user:)
      delete "/api/v1/timer_registers/#{tr.id}"
      expect(response).to have_http_status(:no_content)
      expect(TimerRegister.exists?(tr.id)).to be false
    end
  end
end
