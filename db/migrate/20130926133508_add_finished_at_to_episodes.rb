class AddFinishedAtToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :finished_at, :datetime
  end
end
