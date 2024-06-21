class AddDefalutDeviceIdInAccount < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :default_device_id, :string
    add_column :accounts, :authenticated_data, :json, default: {}
  end
end
