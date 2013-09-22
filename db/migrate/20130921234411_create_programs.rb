class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.time :start_at
      t.integer :length
      t.integer :day_of_week
      t.integer :stream_id

      t.timestamps
    end
  end
end
