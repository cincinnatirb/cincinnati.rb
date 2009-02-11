class AddDetailsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :location_id, :integer
    add_column :events, :topic, :text
    add_column :events, :start_time, :datetime
    add_column :events, :duration, :integer
  end

  def self.down
    remove_column :events, :duration
    remove_column :events, :start_time
    remove_column :events, :topic
    remove_column :events, :location_id
  end
end
