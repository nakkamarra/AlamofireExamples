# AlamofireExamples
A couple of ViewControllers demonstrating a few different ways in which to perform network tasks using [Alamofire](https://github.com/Alamofire/Alamofire). The `AppDelegate` contains commented code for enabling each `ViewController`.

## ViewControllers

The `UIViewController`s defined in this project each serve the purpose of demonstrating a specific aspect [Alamofire](https://github.com/Alamofire/Alamofire), a popular Swift library for handling networking tasks. The descriptions of each controller are as follows: 

* __GithubUserViewController__: makes a request to Github's API and parses the response into a `GithubUser` object. Some details of the user are then display to the user interface, including the user's name, avatar image, and biography.

* __PokemonViewController__: randomly chooses a number between (1...Number Of Pokemon) and then makes a request to Pokéapi's API endpoint for the Pokémon with that number. The response is parsed into a `Pokémon` object. A method then downloads a sprite of the Pokémon which is referenced, and the UI is updated with the sprite image, the Pokémon's name, and the Pokémon's type(s).

* __UploaderViewController__: uses the `UIImagePickerController` to load the operating system's camera and request a photo. The photo that is taken is then uploaded to an API endpoint for testing purposes. The status of the upload is then outputted to the UI. 
