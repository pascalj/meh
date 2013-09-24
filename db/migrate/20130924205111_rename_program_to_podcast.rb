class RenameProgramToPodcast < ActiveRecord::Migration
  def change
    rename_table :programs, :podcasts
    rename_column :episodes, :program_id, :podcast_id
  end
end
