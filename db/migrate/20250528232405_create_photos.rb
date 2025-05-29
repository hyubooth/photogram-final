class CreatePhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :photos do |t|
      t.string :image
      t.string :caption
      t.integer :owner_id
      t.integer :comments_count
      t.integer :likes_count

      t.timestamps
    end
  end
end
