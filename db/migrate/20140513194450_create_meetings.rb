class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :descr
      t.datetime :start_time
      t.datetime :end_time
      t.string :location

      t.timestamps
    end
  end
end
