class CreateTimerRegisters < ActiveRecord::Migration[8.0]
  def change
    create_table :timer_registers do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in,  null: false
      t.datetime :clock_out, null: true

      t.timestamps
    end

    add_index :timer_registers,
              [ :user_id ],
              unique: true,
              where: "clock_out IS NULL",
              name: "idx_unique_open_time_register_per_user"
  end
end
