import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime/model/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 2),
    Band(id: '2', name: 'Metalica', votes: 2),
    Band(id: '3', name: 'Ramones', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Las bandas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) =>
              _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
        elevation: 3,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
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
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[200],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
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
            title: Text('Add Band'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('ADD'),
                onPressed: () {
                  addBandToList(textController.text);
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Dismiss'),
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
            title: Text('add a band'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () {
                  addBandToList(textController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      this.bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
  }
}
