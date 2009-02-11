class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.text :embed_code
      t.string :name
      t.text :details
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
