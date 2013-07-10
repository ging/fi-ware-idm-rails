var Member = (function(SS, $, undefined) {
  var callback = new SS.Callback();

  var initFilter = function() {
    $('.loading').hide();
    $('input[name="contact-filter"]').on('input', filter);
  };

  var filter = function() {
    var q = $(this).val();
    var list = $('.member-list');

    $('#contacts-loading').show();

    $.ajax({
      data: {
        q: q
      },
      dataType: 'html',
      type: 'GET',
      success: function(data) {
        $('#contacts-loading').hide();
        list.html(data);
        callback.handlers.index();
      }
    });
  };

  var initUserSelect2 = function() {
    SS.Actor.select2('input[name="actors"]');
  };

  var initRoleSelect2 = function() {
    $('select[name="relations[]"]').select2();
  };

  callback.register('index',
                    SS.Contact.index,
                    initFilter);

  callback.register('new_',
                    initUserSelect2,
                    initRoleSelect2);

  return callback.extend({
  });

})(SocialStream, jQuery);
