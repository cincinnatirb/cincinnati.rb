ActionController::Routing::Routes.draw do |map|
  map.resources :events, :collection => {:list => :get}
  map.root :controller => 'events', :action => 'index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes"
end
