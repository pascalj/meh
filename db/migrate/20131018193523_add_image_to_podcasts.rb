class AddImageToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :image_uid,  :string
    add_column :podcasts, :image_name, :string
  end
end
