var PermissionCustom = (function(SS, $, undefined) {
  var callback = new SS.Callback();

  var addAndCheckPermission = function(options) {
    var li, input, label, a;

    $('form.edit_relation_custom ul').each(function() {
      li = $('li', this).last().clone();

      input = $('input', li);
      input.attr('id', input.attr('id').replace(/\d+$/, options.custom.id));
      input.attr('value', options.custom.id);

      label = $('label', li);
      label.attr('for', label.attr('for').replace(/\d+$/, options.custom.id));
      label.attr('title', options.custom.description);
      label.html(options.custom.title);

      a = $('a', li);
      if (a.length) {
        a.attr('href', label.attr('href').replace(/\d+$/, options.custom.id));
      }

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

  // Destroy callbacks

  var removeElement = function(options) {
    $('form.edit_relation_custom li:has(input[value="' + options.custom.id + '"])').remove();
  };

  callback.register('create',
                    addAndCheckPermission,
                    resetForms,
                    closeModal);

  callback.register('destroy',
                    removeElement);

  return callback.extend({
  });

})(SocialStream, jQuery);
