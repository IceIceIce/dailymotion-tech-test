# dailymotion-tech-test

## Network Stack
Everything is abstracted trough protocols so everything can be swapped. For example, `URLSession` could be replaced by `Alamofire`. All you have to do is implement the correct protocol. In addition, top layers do not depend on what is used bellow.
All dependencies are injected in `DefaultDataProvider`. If some of them require configurations like the decoder (to specify a date format), the network provider (to specify caching policies or timeouts) it's easily doable when injecting the dependencies in the layer.

## Architecture
The app is implemented using the VIPER architecture. So for the main view controller (video list) you will find a View, Presenter and Interactor.
Using the same pattern, the navigation toward the next view controller is handled via the Router.

All elements are communicating with each other via protocols so every element is mockable and thus testable.

## Error handling
The error handling uses a "bubble mechanism". When an error happens, it is wrapped into an object related to where the error was detected. It's then forwarded to the level above. Each level wraps the error into an new object and can add additional information to help debugging the issue.
Every errors are then forwarded to the `ErrorManager` which takes care of sorting the error and reporting it. Once the error is sorted, it can then be handled by a presenter or forwarded to the Router.

## Future of the app
The app is pretty future proof since we can easily swap components: networking or even UI.
The non monolithic organization also allows to reuse components outside of this app. For example the networking directory could be a reusable package.

A pretty nice feature would be to have an finite scrolling using `UITableViewDataSourcePrefetching`.