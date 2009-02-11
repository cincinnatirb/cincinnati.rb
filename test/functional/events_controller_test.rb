require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase
#   def setup
#     @controller = EventsController.new
#     @request    = ActionController::TestRequest.new
#     @response   = ActionController::TestResponse.new
#   end

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
      post(:create, :user => User::Admin['user'], :password => User::Admin['password'],
           :event => {:date => '12/9/2008',
             :start_time => "18:30", :location_id => 1})
      assert_response :success
    end
  end

  context 'when using shoulda' do
    should 'show events listing' do
      setup do
        get :index
      end
      should_respond_with :success
      should_assign_to :events
    end

    should 'have user and password on the event create form' do
      get :new
      assert_template 'new'
      assert_select 'input[name=user]'
      assert_select 'input[name=password]'
    end
  end
end
