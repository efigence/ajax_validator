RSpec.describe AjaxValidator::ValidatorsController, type: :routing do
  it 'routes to the validator' do
    expect(post: '/validators').
      to route_to(controller: 'ajax_validator/validators', action: 'create')
  end
end
