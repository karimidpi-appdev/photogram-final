class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.integer :owner_id
      t.text :caption
      t.integer :likes_count
      t.integer :comments_count

      t.timestamps
    end
  end
end
