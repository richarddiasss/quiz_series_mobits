class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :actor_name
      t.string :character_name
      t.string :url_photo
      t.references :serie, foreign_key: true

      t.timestamps
    end
  end
end
