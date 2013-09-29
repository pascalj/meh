class AddSlugToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :slug, :string
  end
end
