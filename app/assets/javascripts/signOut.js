var Fiware = Fiware || {};

Fiware.signOut = (function($, undefined) {
  var portals = {
    cloud: {
      name:      'Cloud',
      verb:      'GET',
      protocol:  'http',
      subdomain: 'cloud',
      path:      '/#auth/logout'
    },
    account: {
      name:      'Account',
      verb:      'GET',
      protocol:  'https',
      subdomain: 'account',
      path:      '/users/sign_out'
    }
  };

  var match = window.location.hostname.match(/\.(.*)/);
  var domain = match && match[1];

  // If domain exists, we are in production environment,
  // such as account.testbed.fi-ware.eu
  var productionCall = function(currentPortal) {
    portalCalls = $.map(portals, function(portal) {
      url = portal.protocol + '://' + portal.subdomain + '.' + domain + portal.path;

      return $.ajax(url, { type: portal.verb });
    });

    $.when.apply($, portalCalls).
      always(function() {
        window.location.replace('http://' + domain);
      });
  };

  // Development environment
  var developmentCall = function(currentPortal) {
    var url = 'http://' + window.location.host + portals[currentPortal].path;

    $.ajax(url, {
      type: portals[currentPortal].verb,
      success: function() {
        window.location.replace('http://' + window.location.host);
      }
    });
  };

  var call = function(currentPortal) {
    if (domain) {
      productionCall(currentPortal);
    } else {
      developmentCall(currentPortal);
    }
  };

  return call;

})(jQuery);
