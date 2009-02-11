class Event < ActiveRecord::Base

  belongs_to :location
  validates_presence_of :start_time, :location_id
  
end
