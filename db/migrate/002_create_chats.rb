class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats, force: true do |t|
    	t.string :title
    	t.string :welcome_message, default: 'Welcome to GRAFT, @username! Please read the pinned message before posting. We hope that you’ll join us in revolutionizing the payments industry. Type /help for a list of bot commands.'
    	t.boolean :welcome_on, default: true
      t.timestamps
    end
    change_column :chats, :id,  :integer, limit: 8
  end
end
