require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase

  def test_non_admin_gets_prompted_for_credentials
    get :new
    assert_response :unauthorized
  end

  def test_admin_allowed_to_view_new_event_form
    get :new, :user => User::Admin['user'], :password => User::Admin['password']
    assert_response :success
  end

  def test_non_admin_cannot_create_event
    post :create
    assert_response :forbidden
  end

  def test_admin_can_create_event
    assert_difference "Event.count" do
      post :create, :user => User::Admin['user'], :password => User::Admin['password'], :event => {:date => '12/9/2008'}
      assert_response :success
    end
  end

end