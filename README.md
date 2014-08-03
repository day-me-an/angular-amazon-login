angular-amazon-login
====================
First add it as a dependency to a module and configure it (shown here in CoffeeScript):
```
angular.module 'myModule', ['angular-amazon-login']
  .config (AmazonLoginServiceProvider) -> AmazonLoginServiceProvider.setClientId('my client id')
```

or here  in JavaScript:
```
angular.module('myModule', ['angular-amazon-login']).config(function(AmazonLoginServiceProvider) {
  AmazonLoginServiceProvider.setClientId('my client id');
});
```
then use it somewhere (CoffeeScript):

```
.factory 'MyLoginService', ($q, $log, AmazonLoginService) ->

	loginViaAmazon:) ->
		d = $q.defer()
		AmazonLoginService.then (amazonLogin) -> 
		  # we can now use amazonLogin
		  # eg: amazonLogin.authorize(....)
		return d.promise
```
