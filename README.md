# Remote Control 

Remote control is a mobile app that convert your phone on a controller to your computer. 
<br/>
![presentation_gif](./assets/remote_control.gif)


## Remote_front 📱

This folder contains mobile app, developed in flutter. To run on your machine/device.

1. Get dependencies

`pub get`

2. Change the URL to connect with the socket in 

`services/socketHandler.dart`

- use a [ngrok](https://ngrok.com/) tunnel on port 1978.
 

3. Run the application.

`flutter run`

## Server 🖥️

This folder contains the communication server between the computer and the application, using the lib [robotJS](https://github.com/octalmage/robotjs) and a express webserver. to run on your machine.

1.  Get dependencies

 `yarn`

2. Run server on port 1978

`node index.js`


## TODO list 📑 

- [] Get user IP on front.
- [] Create user friendly way to run server.
- [] Change socket lib on fron-end.
- [] Create splashscreen, icons, and art for the app.
