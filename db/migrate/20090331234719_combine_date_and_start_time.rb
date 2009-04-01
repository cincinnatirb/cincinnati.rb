class CombineDateAndStartTime < ActiveRecord::Migration
  def self.up
    remove_column :events, :start_time
  end

  def self.down
    add_column :events, :start_time, :string
  end
end
