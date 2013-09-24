class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :program_id

      t.timestamps
    end
  end
end
