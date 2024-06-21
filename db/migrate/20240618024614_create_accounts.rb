class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :user_id
      t.string :password
      t.timestamps
    end
  end
end
