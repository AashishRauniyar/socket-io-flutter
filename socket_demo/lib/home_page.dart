import 'package:flutter/material.dart';
import 'package:socket_demo/socket_services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var socketService = SocketService();

  var socketMessage = '';

  @override
  void initState() {
    super.initState();
    socketService.connectAndListen();

    socketService.onLoginEvent = (data) {
      setState(() {
        socketMessage = data;
      });
    };

    socketService.onLogoutEvent = (data) {
      setState(() {
        socketMessage = data;
      });
    };
    socketService.joinSession("aashish");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Socket Demo'),
        ),
        body: Center(
          child: Text(
              socketMessage.isEmpty ? 'Waiting for events...' : socketMessage),
        ));
  }
}
