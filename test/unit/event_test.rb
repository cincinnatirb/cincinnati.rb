require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase

  def test_can_create_new_event
    event = Event.new
    assert event.valid?
  end

  def test_event_should_be_invalid_without_date
    event = Event.new
    assert !event.valid?
  end
end