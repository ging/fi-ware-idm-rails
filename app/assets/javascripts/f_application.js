//= require social_stream/callback

var Application = (function(SS, $, undefined) {
  var callback = new SS.Callback();

  var initTabs = function() {
    var section = window.location.search.match(/section=(\w+)/);

    if (section) {
      // [ "section=other", "other" ]
      section = section[1];
    } else {
      section = 'providing';
    }

    $('.site_clients ul.nav-tabs a').on("show", loadTab);

    $('.site_clients ul.nav-tabs a[href="#' + section + '"]').tab('show');
  };

  var loadTab = function(event) {
    var tab = $(event.target);

    if (tab.attr('data-loaded'))
      return;

    $.ajax({
      url: tab.attr('data-path'),
      data: {
        section: tab.attr('href').substr(1)
      },
      dataType: 'html',
      type: 'GET',
      success: function(data) {
        var id = $(tab).attr('href');
        //XXX changed by KIKE and ALDO. Not the best fix but works
        //we did not know how to add a modal. so we redirect to the original page
        var old_href = $('.new_site_client-modal-link').attr('href');
        $(""+id).html(data);
        $('.new_site_client-modal-link').attr('href', old_href);
        tab.attr('data-loaded', 'true');
      },
      error: function(jqXHR, status, error) {
        SS.Flash.error(error);
      }
    });
  };

  callback.register('index',
                    initTabs);
  

  return callback.extend({
  });

})(SocialStream, jQuery);
