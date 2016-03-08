#~ADD
module RouteHelper
  def self.included(base)
    base.routes { AjaxValidator::Engine.routes }
  end
end
