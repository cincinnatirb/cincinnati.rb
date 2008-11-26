require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase

  def test_can_create_new_event
    event = Event.new
    assert event.valid?
  end

end