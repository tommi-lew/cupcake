class CreatePivotalTrackerStory < ActiveRecord::Migration
  def change
    create_table :pivotal_tracker_stories do |t|
      t.string :tracker_id
      t.string :name
      t.json :data, default: {}
      t.timestamps null: false
    end
  end
end
