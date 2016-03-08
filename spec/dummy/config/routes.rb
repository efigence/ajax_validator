Rails.application.routes.draw do

  mount AjaxValidator::Engine => "/ajax_validator"
end
