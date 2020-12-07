import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime/pages/home.dart';
import 'package:realtime/pages/status.dart';
import 'package:realtime/services/socket_services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SocketService(),
      child: MaterialApp(
        title: 'Material App',
        initialRoute: 'status',
        routes: {
          'home': (_) => HomePage(),
          'status': (_) => StatusPage(),
        },
      ),
    );
  }
}
