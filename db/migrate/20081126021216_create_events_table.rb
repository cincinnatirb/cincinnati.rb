class CreateEventsTable < ActiveRecord::Migration
  def self.up
    create_table :events, :force => true do |t|
      t.datetime    :date
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
