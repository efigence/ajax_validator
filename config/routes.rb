AjaxValidator::Engine.routes.draw do
  resources :validators, only: [:create]
end
