require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase

  def test_can_create_new_event
    event = Event.new(:date => 1.days.ago, :start_time => Time.parse("18:30"), :location_id => 1)
    assert event.valid?
  end
  
  # def test_must_have_title
  #   event = Event.new(:title => 'Newbie night')
  #   assert event.valid?
  # end

  def test_event_should_be_invalid_without_date
    event = Event.new
    assert !event.valid?
  end
  
  should_have_db_columns :location_id, :topic, 
                         :start_time, :duration

  should_belong_to :location
  should_validate_presence_of :location_id, :start_time
end
