class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, force: true do |t|
      t.integer :uid, limit: 5
      t.string :phone
      t.string :fname
      t.string :lname
      t.string :username
      t.string :address
      t.float :latitude
      t.float :longitude
      t.belongs_to :chat, index: true
      t.string :timezone, null:false, default: 'Europe/Kiev'
    end
    change_column :users, :chat_id,  :integer, limit: 8
    change_column :users, :id,  :integer, limit: 8
  end
end
