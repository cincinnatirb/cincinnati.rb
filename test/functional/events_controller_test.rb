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
           :event => {:date => '12/9/2008', :location_id => 1})
      assert_redirected_to events_path
    end
  end

  def valid_event_attributes(options = {})
    {
      :date => 2.days.from_now,
      :topic => "Cincinnati.rb Rocks",
      :duration => 2.hours,
      :location_id => 1,
    }.merge(options)
  end

  def test__event_should_be_valid
    assert Event.new(valid_event_attributes).valid?
  end

  context 'show events listing' do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :events

    context "with events in the past, present, and future" do
      setup do
        @past = Event.create!(valid_event_attributes(:date => 1.days.ago))
        @present = Event.create!(valid_event_attributes(:topic => "Waldo"))
        @future = Event.create!(valid_event_attributes(:date => 8.days.from_now))
        get :index
      end

      should "contain all values for the present event" do
        %w[ date topic  ].each do |key|
          assert_select "td.#{key}", @present[key].to_s
        end
      end
      should "show start_time with no date" do
        assert_raises(Test::Unit::AssertionFailedError, "should not find year in start_time") do
          assert_select "td.start_time", /#{@present.start_time.year}/
        end
      end

      should "show hours and minutes" do
        assert_select "td.start_time", /[^:]\d{1,2}:\d{2}\s+(am|pm)/i
      end
      
      should "check for duration units" do
        assert_select "td.duration", /\d+.*hour/
      end

      should "not show past events" do
        assert ! assigns(:events).include?(@past)
      end

      should "show present events" do
        assert_contains assigns(:events), @present
      end

      should "not show future events" do
        assert_does_not_contain assigns(:events), @future
      end
    end
  end

  context 'when creating an event' do
    setup do
      get :new
    end
    should_assign_to :event
    should_render_template :new
    should "post to the correct url" do
      assert_select "form[action=?]", events_path
    end
    should_have_fields :user, :password
    should_have_fields :location_id, :topic, :duration, :for => :event
    should "have a date select control" do
      assert_select "#event_date_1i"
    end
    should "have a submit button" do
      assert_select "input[type='submit']"
    end
  end

  context 'when creating an invalid event' do
    setup do
      post :create, :user => User::Admin['user'],
                    :password => User::Admin['password'],
                    :event => { :date => '12/9/2008' }
    end
    should_render_template :new

    should "display error and retain entered values" do
      assert_select ".fieldWithErrors"
    end
  end

end
