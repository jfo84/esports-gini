class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.integer :player_id
      t.integer :game_id

      t.jsonb :data

      t.timestamps
    end
  end
end
