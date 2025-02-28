class CreateSeries < ActiveRecord::Migration[5.2]
  def change
    create_table :series do |t|
      t.integer :id_serie
      t.string :name_pt
      t.string :original_name
      t.string :country
      t.float :popularity
      t.float :average_voting
      t.text :synopsis
      t.string :url_photo

      t.timestamps
    end
  end
end
