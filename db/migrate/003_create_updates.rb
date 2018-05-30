class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates, force: true do |t|
    	t.string :yt_channel_1
    	t.string :yt_channel_2
    	t.string :website_link
      t.timestamps
    end
    change_column :chats, :id,  :integer, limit: 8
  end
end