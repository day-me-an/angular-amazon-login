angular.module('angular-amazon-login', []).provider('AmazonLoginService', function() {

  /*
  	PRIVATE:
   */
  var attachScript, config, self;
  config = {
    clientId: null,
    scriptUrl: 'https://api-cdn.amazon.com/sdk/login1.js',
    timeout: 3000
  };
  attachScript = function(_document) {

    /*
    		Appends a <script> tag for the SDK to the DOM.
     */
    var dest, tag, _ref;
    tag = _document.createElement('script');
    tag.type = 'text/javascript';
    tag.src = config.scriptUrl;
    dest = (_ref = _document.getElementById('amazon-root')) != null ? _ref : _document.getElementsByTagName('head')[0];
    return dest.appendChild(tag);
  };

  /*
  	PUBLIC:
   */
  return self = {
    setScriptUrl: function(value) {

      /*
      			Sets the URL of the JavaScript to load.
       */
      config.scriptUrl = value;
      return self;
    },
    setClientId: function(value) {

      /*
      			Sets the non-secret API key.
       */
      config.clientId = value;
      return self;
    },
    setTimeout: function(value) {

      /*
      			Sets the milliseconds it should wait for the API to load.
       */
      config.timeout = value;
      return self;
    },
    $get: [
      '$document', '$timeout', '$q', '$window', '$log', function($document, $timeout, $q, $window, $log) {

        /*
        			Returns a promise that resolves to `amazon.Login`.
        			Otherwise it rejects if it couldn't load it in time.
         */
        var d, loadFailureCallback, loadTimer;
        d = $q.defer();
        loadFailureCallback = function() {
          $log.error("Amazon Login JavaScript SDK has not loaded after " + config.timeout + "ms");
          return d.reject();
        };
        loadTimer = $timeout(loadFailureCallback, config.timeout);
        $window.onAmazonLoginReady = function() {
          $timeout.cancel(loadTimer);
          $window.amazon.Login.setClientId(config.clientId);
          $log.debug("amazon.Login has loaded successfully");
          return d.resolve($window.amazon.Login);
        };
        attachScript($document[0]);
        return d.promise;
      }
    ]
  };
}).factory('AmazonLogin', [
  '$q', '$log', 'AmazonLoginService', function($q, $log, AmazonLoginService) {
    return {
      authorize: function(options) {
        var d;
        d = $q.defer();
        AmazonLoginService.then(function(amazonLogin) {
          return amazonLogin.authorize(options, function(resp) {
            if (resp.error) {
              $log.debug("amazon.Login.authorize() responded with error: " + resp.error);
              return d.reject(resp.error);
            } else {
              return d.resolve(resp);
            }
          });
        });
        return d.promise;
      }
    };
  }
]);

//# sourceMappingURL=angular-amazon-login.js.map