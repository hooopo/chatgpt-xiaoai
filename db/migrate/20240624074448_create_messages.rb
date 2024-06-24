class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :device_id
      t.bigint :account_id
      t.bigint :time
      t.text :query
      t.string :request_id
      t.string :role, default: "user"
      t.timestamps
      t.index :device_id
      t.index :request_id
      t.index [ :device_id, :time ]
    end
  end
end
