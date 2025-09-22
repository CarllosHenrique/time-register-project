class CreateReportProcesses < ActiveRecord::Migration[8.0]
  def change
    create_table :report_processes do |t|
      t.string :uid, null: false
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: "queued"
      t.integer :progress, null: false, default: 0
      t.string :file_path
      t.datetime :started_at
      t.datetime :finished_at
      t.text :error

      t.timestamps
    end
    add_index :report_processes, :uid
  end
end
