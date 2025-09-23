# db/seeds.rb
require "faker"

ActiveRecord::Base.transaction do
  # 100 usuários estáveis por email (idempotente)
  (1..100).each do |i|
    User.find_or_create_by!(email: "user#{i}@example.com") do |u|
      u.name = Faker::Name.name
    end
  end

  puts "Users prontos: #{User.count}"

  User.find_each do |user|
    # Se já tem >= 20, pula (idempotente simples)
    next if user.timer_registers.count >= 20

    # gere datas distribuídas nos últimos ~4 meses
    base_days = (1..120).to_a.sample(20).sort
    base_days.each do |d|
      day = d.days.ago.to_date
      clock_in  = Time.zone.local(day.year, day.month, day.day, 8 + rand(0..1), [ 0, 5, 10, 15, 20 ].sample)
      lunch_out = clock_in + 4.hours + rand(0..20).minutes
      lunch_in  = lunch_out + 1.hour + rand(0..15).minutes
      clock_out = lunch_in + 4.hours + rand(0..20).minutes

      # introduz leve variação (“chegou tarde”, etc.)
      clock_in  += rand(-10..15).minutes
      clock_out += rand(-10..25).minutes

      # cria dois registros: manhã e tarde (exemplificando pausas)
      # (ou, se preferir, apenas um consolidado por dia — aqui faremos um consolidado)
      user.timer_registers.create!(
        clock_in:  clock_in,
        clock_out: clock_out
      )
    end
  end

  puts "TimeRegisters prontos: #{TimerRegister.count}"
end
