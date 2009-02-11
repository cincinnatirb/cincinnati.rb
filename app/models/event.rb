class Event < ActiveRecord::Base

  belongs_to :location
  validates_presence_of :date
  
end