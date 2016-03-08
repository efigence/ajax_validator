=begin
When I go to the user form for "foo@bar.de"               # goes to edit_user_path(User.find_by_anything!('foo@bar.de'))
When I go to the form for the user "foo@bar.de"           # goes to edit_user_path(User.find_by_anything!('foo@bar.de'))
When I go to the form for the user above"                 # goes to edit_user_path(User.last)
When I go to the project page for "World Domination"      # goes to project_path(Project.find_by_anything!('World Domination')
When I go to the page for the project "World Domination"  # goes to project_path(Project.find_by_anything!('World Domination')
When I go to the page for the user above                  # goes to user_path(User.last)
When I go to the user form                                # goes to new_user_path
When I go to the list of users                            # goes to users_path
=end
module NavigationHelpers

  def path_to(page_name)
    case page_name

    when /^the list of (.*?)$/
      models_prose = $1
      route = "#{model_prose_to_route_segment(models_prose)}_path"
      send(route)

    when /^the (page|form) for the (.*?) above$/
      action_prose, model_prose = $1, $2
      route = "#{action_prose == 'form' ? 'edit_' : ''}#{model_prose_to_route_segment(model_prose)}_path"
      model = model_prose.classify.constantize
      send(route, model.last)

    when /^the (page|form) for the (.*?) "(.*?)"$/
      action_prose, model_prose, identifier = $1, $2, $3
      path_to_show_or_edit(action_prose, model_prose, identifier)

    when /^the (.*?) (page|form) for "(.*?)"$/
      model_prose, action_prose, identifier = $1, $2, $3
      path_to_show_or_edit(action_prose, model_prose, identifier)

    when /^the (.*?) form$/
      model_prose = $1
      route = "new_#{model_prose_to_route_segment(model_prose)}_path"
      send(route)

    # ....
    # your own paths go here
    # ...
    end

  end

  private

  def path_to_show_or_edit(action_prose, model_prose, identifier)
    model = model_prose.classify.constantize
    route = "#{action_prose == 'form' ? 'edit_' : ''}#{model_prose_to_route_segment(model_prose)}_path"
    send(route, model.find_by_anything!(identifier))
  end

  def model_prose_to_route_segment(model_prose)
    model_prose.gsub(/[\ \/]/, '_')
  end

end

World(NavigationHelpers)
