import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  get serverStatus => _serverStatus;
  SocketService() {
    print("Socket service created");
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    print('trying to connect');
    IO.Socket socket = IO.io('http://localhost:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    socket.onConnect((_) {
      print("client Connected ");
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    socket.onDisconnect((data) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    /*
    IO.Socket socket = IO.io('http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((_) {
      print('connect');
    });
    socket.onDisconnect((_) => print('disconnected'));
    */
  }
}
