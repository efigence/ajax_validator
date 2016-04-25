Rails.application.routes.draw do
  resource :base, only: :index
  mount AjaxValidator::Engine => "/ajax_validator"
end
