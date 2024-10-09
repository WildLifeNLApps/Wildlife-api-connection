<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

The package can be used by the various WildlifeNL apps in order to make calls to the API. This way there will be less duplicate code shared across the various apps.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.
When using this app pass an instance of the ApiClient class from this package to the API class which you want to use and then simply call the functions defined within the API class.

```dart
const apiClient = ApiClient("baseUrl")
const authApi = AuthApi(apiClient)
```

## Additional information
The package depends on the following other packages:
http: ^1.2.2
shared_preferences: ^2.3.2
