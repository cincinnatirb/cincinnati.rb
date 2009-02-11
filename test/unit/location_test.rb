require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  should_validate_presence_of :name, :address

end
