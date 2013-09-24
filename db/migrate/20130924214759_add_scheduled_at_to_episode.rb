class AddScheduledAtToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :scheduled_at, :datetime
  end
end
