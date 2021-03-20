import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

const String URI = "http://4df1eb0e03bf.ngrok.io";

class SocketHandler {
  SocketIO socketIO;

  SocketHandler() {
    socketIO = SocketIOManager().createSocketIO(
      URI,
      "/",
    );
    socketIO.init();
    socketIO.connect();
  }

  void moveMouse(double x, double y) {
    if (socketIO != null) {
      socketIO.sendMessage('moveMouse', '{"x":"$x","y":"$y"}');
    }
  }

  void clickButtton(String button) {
    if (socketIO != null) {
      socketIO.sendMessage('clickMouse', '{"button":"$button"}');
    }
  }

  void typeKey(String letter, String moddifier) {
    if (socketIO != null) {
      socketIO.sendMessage(
          'typeKey', '{"key":"$letter", "moddifier":"$moddifier"}');
    }
  }

  void disconnectSocket() {
    if (socketIO != null) {
      socketIO.disconnect();
    }
  }

  void destroySocket() {
    if (socketIO != null) {
      SocketIOManager().destroySocket(socketIO);
    }
  }
}
