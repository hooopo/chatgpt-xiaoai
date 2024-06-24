class CreateDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :devices, id: false do |t|
      t.bigint :account_id
      t.string :device_id, primary_key: true
      t.string :serial_number
      t.string :name
      t.string :alias
      t.boolean :current
      t.string :presence
      t.string :address
      t.string :miot_did
      t.string :hardware
      t.string :rom_version
      t.json :capabilities
      t.string :remote_ctrl_type
      t.text :device_sn_profile
      t.text :device_profile
      t.timestamps
    end
  end
end
