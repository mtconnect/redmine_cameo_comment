# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

post '/cameo_comment', action: :create, controller: 'cameo_comment'
get '/cameo_comment/check', action: :check, controller: 'cameo_comment' 
