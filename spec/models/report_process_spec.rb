# spec/models/report_process_spec.rb
require 'rails_helper'

RSpec.describe ReportProcess, type: :model do
  let(:user) { create(:user) }

  it "é válido com atributos mínimos" do
    rp = described_class.new(user: user, status: "queued", progress: 0)
    expect(rp).to be_valid
    rp.save!
    expect(rp.uid).to be_present # ensure_uid gerou UID
  end

  it "gera uid automaticamente no create" do
    rp = described_class.create!(user: user, status: "queued", progress: 0)
    expect(rp.uid).to be_present
  end

  it "valida unicidade do uid" do
    uid = SecureRandom.uuid
    described_class.create!(user: user, status: "queued", progress: 0, uid: uid)
    dup = described_class.new(user: user, status: "queued", progress: 0, uid: uid)
    expect(dup).not_to be_valid
    expect(dup.errors[:uid]).to be_present
  end

  it "valida faixa de progress (0..100)" do
    expect(described_class.new(user: user, status: "queued", progress: -1)).not_to be_valid
    expect(described_class.new(user: user, status: "queued", progress: 101)).not_to be_valid
    expect(described_class.new(user: user, status: "queued", progress: 0)).to be_valid
    expect(described_class.new(user: user, status: "queued", progress: 100)).to be_valid
  end

  it "define enum de status com helpers *_queued?/processing?/completed?/failed?" do
    rp = described_class.create!(user: user, status: "queued", progress: 0)
    expect(rp.status).to eq("queued")
    expect(rp.status_queued?).to be true
    rp.update!(status: "processing")
    expect(rp.status_processing?).to be true
  end

  it "pertence a um usuário" do
    rp = described_class.new(status: "queued", progress: 0)
    expect(rp).not_to be_valid
    expect(rp.errors[:user]).to be_present
  end
end
