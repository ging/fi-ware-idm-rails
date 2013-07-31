var PermissionCustom = (function(SS, $, undefined) {
  var callback = new SS.Callback();

  var addAndCheckPermission = function(options) {
    var li, input, label;

    $('form.edit_relation_custom ul').each(function() {
      li = $('li', this).last().clone();

      input = $('input', li);
      input.attr('id', input.attr('id').replace(/\d+$/, options.custom.id));
      input.attr('value', options.custom.id);

      label = $('label', li);
      label.attr('for', label.attr('for').replace(/\d+$/, options.custom.id));
      label.attr('title', options.custom.description);
      label.html(options.custom.title);

      $(this).append(li);
    });
  };

  var resetForms = function() {
    $('form.new_permission_custom').each(function() {
      this.reset();

      $('.error_explanation', this).html('');
    });
  };

  var closeModal = function() {
    $('#new_permission_modal').modal('hide');
  };

  callback.register('create',
                    addAndCheckPermission,
                    resetForms,
                    closeModal);

  return callback.extend({
  });

})(SocialStream, jQuery);
