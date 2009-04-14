class Event < ActiveRecord::Base

  belongs_to :location
  validates_presence_of :location_id

  def to_s
    "#{self.date.to_date} #{self.start_time.to_s(:hhmm_p)} - #{self.topic} (#{self.location.name})"
  end

  def start_time
    self.date
  end

  def self.next
    Event.first(:conditions => ['date >= ?', Date.today],
                :order => 'date asc')
  end

end
