class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :username
      t.integer :likes_count
      t.integer :comments_count
      t.boolean :private

      t.timestamps
    end
  end
end
