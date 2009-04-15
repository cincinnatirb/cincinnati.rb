class Location < ActiveRecord::Base
  has_many :events
  validates_presence_of :name, :address

  def to_s
    "#{self.id}: #{self.name}; #{self.address}"
  end
end
