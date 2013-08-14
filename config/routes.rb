ActionController::Routing::Routes.draw do |map|
  map.connect 'context_menu_watchers/:action', :controller => 'context_menu_watchers'
end
