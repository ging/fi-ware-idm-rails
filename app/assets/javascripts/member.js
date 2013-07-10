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

  callback.register('index',
                    SS.Contact.index,
                    initFilter);

  return callback.extend({
  });

})(SocialStream, jQuery);
