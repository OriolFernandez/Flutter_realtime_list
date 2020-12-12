import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  ServerStatus get serverStatus => _serverStatus;

  IO.Socket _socket;
  IO.Socket get socket => this._socket;

  SocketService() {
    print("Socket service created");
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    print('trying to connect');
    _socket = IO.io('http://localhost:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      print("client Connected ");
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.onDisconnect((data) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('message', (payload) {
      print("Message recived : $payload");
    });
  }

  void sendMessage(String s) {
    _socket.emit('message', s);
  }
}
