require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase
  def self.should_have_fields(*fields)
    options = {}
    options = fields.pop if fields && fields.last.is_a?(Hash)
    model = options[:for]
    fields.each do |field|
      name = model ? "#{model}[#{field}]" : field.to_s
      should "test: should have field named #{name}" do
        assert_select "input[name=?]", "#{name}"
      end
    end
  end

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

  context 'show events listing' do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :events
  end

  context 'when creating an event' do
    setup do
      get :new
    end
    should_render_template :new

    should_have_fields :user, :password
    should_have_fields :location_id, :start_time, :date, :topic, :duration, :for => :event

    should "have a submit button" do
      assert_select "input[type='submit']"
    end
  end
end
