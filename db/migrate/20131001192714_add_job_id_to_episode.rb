class AddJobIdToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :job_id, :string
  end
end
