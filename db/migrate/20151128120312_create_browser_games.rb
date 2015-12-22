class CreateBrowserGames < ActiveRecord::Migration
  def change
    create_table :browser_games do |t|
      t.string :name, default: "one of my games"
      t.string :status, default: '0'*100
      t.integer :amount_of_steps, default: 0
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :browser_games, [:user_id, :created_at]
  end
end
