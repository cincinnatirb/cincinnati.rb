class EventsController < ApplicationController
  def index
    @events = Event.find(:all)
  end

  def new
    unless User.authenticate(params[:user], params[:password])
      render :status => :unauthorized
    end
    @event = Event.new
  end

  def create
    unless User.authenticate(params[:user], params[:password])
      render :status => :forbidden
      return
    end
    @event = Event.create params[:event]
    if @event.valid?
      redirect_to events_path
    else
      render :action => "new"
    end
  end
end
