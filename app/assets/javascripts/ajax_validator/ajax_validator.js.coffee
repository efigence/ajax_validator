window.ajax_validator_timeout = undefined

$(document).on 'ready', (_event) ->
  $('form').on 'keydown', '.ajax_validator__field', (e) ->

    form_object = $(@).data('form-object')
    resource_model = $(@).data('resource-model')
    resource_attr_name = $(@).data('resource-attr-name')
    ignore_resource_attr_value = $(@).data('ignore-resource-attr-value')
    resource_instance_additional_params = $(@).data('resource-instance-additional-params')

    queue_id = form_object + '-' + resource_model + resource_attr_name

    $(document).queue queue_id, (next) =>

      parent_div = $(@).parents('div').eq(0)
      resource_attr_value = $(@).val()

      $.ajax
        url: "/ajax_validator/validators"
        type: "POST"
        dataType: "json"
        data:
          'validator':
            'form_object': form_object
            'resource_model': resource_model
            'resource_attr_name': resource_attr_name
            'resource_attr_value': resource_attr_value
            'ignore_resource_attr_value': ignore_resource_attr_value
            'resource_instance_additional_params': resource_instance_additional_params
        success: (returnData) ->
          if parent_div
            if returnData['errors'].length > 0
              $(parent_div).removeClass("has-error has-success").addClass("has-error")
            else
              $(parent_div).removeClass("has-error has-success").addClass("has-success")
          else
            $('body').html(JSON.stringify returnData)
        error: (e) ->
          # console.log(JSON.stringify e)

    clearTimeout(ajax_validator_timeout);

    window.ajax_validator_timeout = setTimeout((->
      $(document).dequeue queue_id
    ), 1000)
