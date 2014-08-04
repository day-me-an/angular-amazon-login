angular-amazon-login
====================
## Install

Include the JS file located in the `./build` directory or simply use bower:

```shell
bower install -S angular-amazon-login
```
## Usage

First add it as a dependency to a module and configure it with your API key:
```coffeescript
angular.module 'myModule', ['angular-amazon-login']
  .config (AmazonLoginServiceProvider) -> AmazonLoginServiceProvider.setClientId('my api key')
```

then use it somewhere:

```coffeescript
.factory 'MyLoginService', ($q, $log, AmazonLogin) ->

	loginWithAmazon: ->
		###
		Triggers the Login with Amazon window to show
		###
		AmazonLogin.authorize(scope: 'profile')
			.then (resp) -> console.log "hello #{resp.profile.name}"
			# otherwise the promise rejects if the operation failed
			.catch (error) -> console.log "login failed due to #{error}"
	
```
