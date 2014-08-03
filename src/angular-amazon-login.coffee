angular.module 'angular-amazon-login', []


.provider 'AmazonLoginService', ->
	###
	PRIVATE:
	###
	config =
		clientId: null
		scriptUrl: 'https://api-cdn.amazon.com/sdk/login1.js'
		timeout: 3000

	attachScript = (_document) ->
		###
		Appends a <script> tag for the SDK to the DOM.
		###
		tag = _document.createElement('script')
		tag.type = 'text/javascript'
		tag.src = config.scriptUrl
		# it's supposed to go into something with id="amazon-root", but fallback to <head> otherwise
		dest = _document.getElementById('amazon-root') ? _document.getElementsByTagName('head')[0]
		dest.appendChild(tag)

	###
	PUBLIC:
	###
	self = 
		setScriptUrl: (value) ->
			###
			Sets the URL of the JavaScript to load.
			###
			config.scriptUrl = value
			return self

		setClientId: (value) ->
			###
			Sets the non-secret API key.
			###
			config.clientId = value
			return self

		setTimeout: (value) ->
			config.timeout = value
			return self

		$get: ['$document', '$timeout', '$q', '$window', '$log', ($document, $timeout, $q, $window, $log) ->
			###
			Returns a promise that resolves to `amazon.Login`.
			Otherwise it rejects if it couldn't load it in time.
			###
			d = $q.defer()
			# reject and log an error if it doesn't load in time
			loadFailureCallback = ->
				$log.error "Amazon Login JavaScript SDK has not loaded after #{config.timeout}ms"
				d.reject()
			loadTimer = $timeout(loadFailureCallback, 5000)
			# resolve to `amazon.Login` once it's loaded
			$window.onAmazonLoginReady = ->
				# prevent the loadFailureCallback being triggered
				$timeout.cancel(loadTimer)
				$window.amazon.Login.setClientId(config.clientId)
				$log.debug "amazon.Login has loaded successfully"
				d.resolve($window.amazon.Login)
			# create the script
			attachScript($document[0])
			return d.promise
		]


.factory 'AmazonLogin', ['$q', '$log', 'AmazonLoginService', ($q, $log, AmazonLoginService) ->

	authorize: (options) ->
		d = $q.defer()
		AmazonLoginService.then (amazonLogin) -> amazonLogin.authorize options, (resp) ->
			if not resp?.success
				$log.error "amazon.Login.authorize failed due to #{resp.error}"
				# reject with returned error message
				d.reject(resp.error)
			else
				d.resolve(resp)
		return d.promise
]