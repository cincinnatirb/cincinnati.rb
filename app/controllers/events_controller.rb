class EventsController < ApplicationController
  def index
    @events = Event.find(:all)
  end

  def new
    unless User.authenticate(params[:user], params[:password])
      render :status => :unauthorized
    end
  end

  def create
    unless User.authenticate(params[:user], params[:password])
      render :status => :forbidden
      return
    end
    Event.create! params[:event]
    redirect_to events_path
  end
end
