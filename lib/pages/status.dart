import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime/services/socket_services.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketSevice, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${socketSevice.serverStatus}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
