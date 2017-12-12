Rails.application.routes.draw do
  root :to => 'code#execute'
  get 'code/execute'
  
  post 'code/submitcode' , to: 'code#submitcode'
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
	