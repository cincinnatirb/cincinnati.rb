class Event < ActiveRecord::Base

  belongs_to :location
  validates_presence_of :location_id

  def pretty_date
    self.date.to_date.to_s
  end

  def start_time
    self.date.to_s(:hhmm_p)
  end

  def location_name
    self.location.name
  end

  def pretty_duration
    self.duration.to_s << " hours"
  end

  def to_s
    "#{pretty_date} #{pretty_start_time} - #{self.topic} (#{location_name})"
  end

  def self.next
    Event.first(:conditions => ['date >= ?', Time.zone.now],
                :order => 'date asc')
  end
end
