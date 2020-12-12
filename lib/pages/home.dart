import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime/model/item.dart';
import 'package:realtime/services/socket_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> _items = [];
  @override
  void initState() {
    final SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('current-items', (payload) {
      _items = (payload as List).map((item) => Item.fromMap(item)).toList();
      print("Current items $_items");
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    final SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('current-items');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SocketService socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de la compra',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[400],
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.actionOnServiceStatus(),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) =>
              _bandTile(_items[index])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
        elevation: 3,
      ),
    );
  }

  Widget _bandTile(Item item) {
    final SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(item.id),
      onDismissed: (_) {
        // TODO call BE
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 8),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(item.name.substring(0, 2)),
          backgroundColor: Colors.blue[200],
        ),
        title: Text("${item.name}"),
        trailing: Text(
          '${item.numberToBuy}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print("Tap on ${item.id}");
          socketService.socket.emit('increase-item', {'id': item.id});
        },
      ),
    );
  }

  void addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      showAndroidDialog(textController);
    } else {
      showIOSDialog(textController);
    }
  }

  void showIOSDialog(TextEditingController textController) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Añadir producto'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Añadir'),
                onPressed: () {
                  addItemToList(textController.text);
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  void showAndroidDialog(TextEditingController textController) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Añadir producto'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text('Añadir'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () {
                  addItemToList(textController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void addItemToList(String name) {
    if (name.length > 1) {
      this
          ._items
          .add(Item(id: DateTime.now().toString(), name: name, numberToBuy: 1));
      setState(() {});
    }
  }
}

extension ServiceSocketExtension on SocketService {
  Widget actionOnServiceStatus() {
    Widget _widget;
    switch (this.serverStatus) {
      case ServerStatus.Online:
        _widget = Icon(Icons.check_circle, color: Colors.green);
        break;
      case ServerStatus.Offline:
        _widget = Icon(Icons.check_circle, color: Colors.red);
        break;
      case ServerStatus.Connecting:
        _widget = Icon(Icons.check_circle, color: Colors.blue);
        break;
    }
    return _widget;
  }
}
