class Event < ActiveRecord::Base

  belongs_to :location
  validates_presence_of :start_time, :location_id

  def to_s
    "#{self.date.to_date} #{self.start_time.to_s(:hhmm_p)} - #{self.topic} (#{self.location.name})"
  end
end
