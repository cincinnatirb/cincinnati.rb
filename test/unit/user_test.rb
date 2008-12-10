require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  def setup
    @user = User::Admin['user']
    @password = User::Admin['password']

    @baduser = "harvey" + @user
    @badpassword = "bar" + @password
  end

  def test_can_authenticate_if_user_password_is_known
    assert User.authenticate(@user, @password), "user should be authenticated"
  end

  def test_will_not_authenticate_if_password_is_wrong
    assert ! User.authenticate(@user, @badpassword), "user should be rejected"
  end

  def test_will_not_authenticate_if_user_is_wrong
    assert ! User.authenticate(@baduser, @password), "user should be rejected"
  end
end
