class RenameImageToImageUrlForPhotos < ActiveRecord::Migration[6.0]
  def change
    rename_column :photos, :image, :image_url
    add_column :photos, :image, :string
  end
end
