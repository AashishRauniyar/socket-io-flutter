// // import 'package:flutter/material.dart';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: ChatPage(),
// //     );
// //   }
// // }

// // class ChatPage extends StatefulWidget {
// //   @override
// //   _ChatPageState createState() => _ChatPageState();
// // }

// // class _ChatPageState extends State<ChatPage> {
// //   late IO.Socket socket;
// //   TextEditingController _controller = TextEditingController();
// //   List<String> messages = [];

// //   List<String> serverMessages = [];

// //   @override
// //   void initState() {
// //     super.initState();

// //     // Connect to the server (replace 'localhost' with the actual IP for physical devices)
// //     socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
// //       'transports': ['websocket'],
// //     });

// //     // When connected to the server, log the event
// //     socket.on('connect', (_) {
// //       print('Connected to server');
// //     });

// //     // Listen for incoming messages from the server
// //     socket.on('chat_message', (msg) {
// //       print('Received message: $msg');
// //       setState(() {
// //         messages.add(msg); // Add message to the list
// //       });
// //     });

// //     socket.on('server_message', (msg) {
// //       print('Received message: $msg');
// //       setState(() {
// //         serverMessages.add(msg); // Add message to the list
// //       });
// //     });

// //     // Handle socket disconnection
// //     socket.on('disconnect', (_) {
// //       print('Disconnected from server');
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     socket.dispose();
// //     super.dispose();
// //   }

// //   // Send message to the server
// //   void _sendMessage() {
// //     if (_controller.text.isNotEmpty) {
// //       socket.emit('chat_message', _controller.text); // Emit message
// //       setState(() {
// //         messages.add(_controller.text); // Display message locally
// //       });
// //       _controller.clear(); // Clear the input field
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Socket.IO Chat')),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: messages.length + serverMessages.length,
// //               itemBuilder: (context, index) {
// //                 String message;
// //                 Color messageColor;

// //                 // Determine if it's a normal message or a server message
// //                 if (index < messages.length) {
// //                   message = messages[index];
// //                   messageColor = Colors.black; // Normal message color
// //                 } else {
// //                   message = serverMessages[index - messages.length];
// //                   messageColor = Colors.red; // Server message color
// //                 }

// //                 return ListTile(
// //                   title: Text(
// //                     message,
// //                     style: TextStyle(color: messageColor), // Apply color based on message type
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _controller,
// //                     decoration: InputDecoration(hintText: 'Type a message'),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send),
// //                   onPressed: _sendMessage,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// // }

// //? room app

// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChatPage(),
//     );
//   }
// }

// class ChatPage extends StatefulWidget {
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   late IO.Socket socket;
//   TextEditingController _controller = TextEditingController();
//   List<String> messages = [];
//   String roomName = '';
//   String userMessage = '';
//   bool isInRoom = false;

//   @override
//   void initState() {
//     super.initState();

//     // Connect to the server
//     socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     socket.on('connect', (_) {
//       print('Connected to server');
//     });

//     socket.on('room_message', (msg) {
//       setState(() {
//         userMessage = msg;
//       });
//     });

//     socket.on('receive_message', (msg) {
//       setState(() {
//         messages.add(msg);
//       });
//     });

//     socket.on('disconnect', (_) {
//       print('Disconnected from server');
//     });
//   }

//   @override
//   void dispose() {
//     socket.dispose();
//     super.dispose();
//   }

//   // Create a room
//   void _createRoom() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         roomName = _controller.text;
//         isInRoom = true;
//       });
//       socket.emit('create_room', roomName);
//       _controller.clear();
//     }
//   }

//   // Join an existing room
//   void _joinRoom() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         roomName = _controller.text;
//         isInRoom = true;
//       });
//       socket.emit('join_room', roomName);
//       _controller.clear();
//     }
//   }

//   // Send a message to the room
//   void _sendMessage() {
//     if (_controller.text.isNotEmpty && isInRoom) {
//       // Emit the message along with the room name as an object
//       socket.emit('send_message', {'room': roomName, 'message': _controller.text});
//       setState(() {
//         messages.add('You: ${_controller.text}');
//       });
//       _controller.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Socket.IO Chat')),
//       body: Column(
//         children: [
//           // Room creation and joining section
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(hintText: 'Enter room name'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: _createRoom,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.exit_to_app),
//                   onPressed: _joinRoom,
//                 ),
//               ],
//             ),
//           ),
//           Text(userMessage),  // Display room-related messages
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(messages[index]),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(hintText: 'Type a message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ChatPage(),
//     );
//   }
// }

// class ChatPage extends StatefulWidget {
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   late IO.Socket socket;
//   TextEditingController _controller = TextEditingController();
//   List<String> messages = [];
//   String roomName = '';
//   String userMessage = '';
//   bool isInRoom = false;

//   @override
//   void initState() {
//     super.initState();

//     // Connect to the server
//     socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     socket.on('connect', (_) {
//       print('Connected to server');
//     });

//     socket.on('room_message', (msg) {
//       // Add room message only if it isn't already in the list
//       if (!messages.contains(msg)) {
//         setState(() {
//           userMessage = msg;
//         });
//       }
//     });

//     socket.on('receive_message', (msg) {
//       // Add chat messages only if they aren't already in the list
//       if (!messages.contains(msg)) {
//         setState(() {
//           messages.add(msg);
//         });
//       }
//     });

//     socket.on('disconnect', (_) {
//       print('Disconnected from server');
//     });
//   }

//   @override
//   void dispose() {
//     socket.dispose();
//     super.dispose();
//   }

//   // Create a room
//   void _createRoom() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         roomName = _controller.text;
//         isInRoom = true;
//       });
//       socket.emit('create_room', roomName);
//       _controller.clear();
//     }
//   }

//   // Join an existing room
//   void _joinRoom() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         roomName = _controller.text;
//         isInRoom = true;
//       });
//       socket.emit('join_room', roomName);
//       _controller.clear();
//     }
//   }

//   // Send a message to the room
//   void _sendMessage() {
//     if (_controller.text.isNotEmpty && isInRoom) {
//       // Emit the message along with the room name as an object
//       socket.emit('send_message', {'room': roomName, 'message': _controller.text});
//       setState(() {
//         messages.add('You: ${_controller.text}');
//       });
//       _controller.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Socket.IO Chat'),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         children: [
//           // Room creation and joining section
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: 'Enter room name',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.all(10),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: _createRoom,
//                   tooltip: 'Create Room',
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.exit_to_app),
//                   onPressed: _joinRoom,
//                   tooltip: 'Join Room',
//                 ),
//               ],
//             ),
//           ),
//           if (userMessage.isNotEmpty)
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 userMessage,
//                 style: TextStyle(fontSize: 16, color: Colors.blue),
//               ),
//             ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(
//                     messages[index],
//                     style: TextStyle(
//                       color: messages[index].startsWith('You: ') ? Colors.black : Colors.green,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.all(10),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                   tooltip: 'Send Message',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  TextEditingController _controller = TextEditingController();
  TextEditingController _roomController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  List<String> messages = [];
  List<String> rooms = []; // Store available rooms
  String roomName = '';
  String username = '';
  bool isInRoom = false;

  @override
  void initState() {
    super.initState();

    // Connect to the server
    socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to server');
    });

    socket.on('room_created', (room) {
      setState(() {
        rooms.add(room);
      });
    });

    socket.on('receive_message', (data) {
      setState(() {
        messages.add('${data['username']}: ${data['message']}');
      });
    });

    socket.on('room_message', (msg) {
      setState(() {
        messages.add(msg);
      });
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  // Create a room
  void _createRoom() {
    if (_roomController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {
      setState(() {
        roomName = _roomController.text;
        username = _usernameController.text;
        isInRoom = true;
      });
      socket.emit('create_room', {'room': roomName, 'username': username});
      _roomController.clear();
      _usernameController.clear();
    }
  }

  // Join an existing room
  void _joinRoom() {
    if (_roomController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {
      setState(() {
        roomName = _roomController.text;
        username = _usernameController.text;
        isInRoom = true;
      });
      socket.emit('join_room', {'room': roomName, 'username': username});
      _roomController.clear();
      _usernameController.clear();
    }
  }

  // Send a message to the room
  void _sendMessage() {
    if (_controller.text.isNotEmpty && isInRoom) {
      socket.emit('send_message', {
        'room': roomName,
        'username': username,
        'message': _controller.text
      });
      setState(() {
        messages.add('You: ${_controller.text}');
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Socket.IO Chat')),
      body: Column(
        children: [
          // Room creation and joining section
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(hintText: 'Enter username'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _roomController,
                    decoration: InputDecoration(hintText: 'Enter room name'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _createRoom,
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: _joinRoom,
                ),
              ],
            ),
          ),
          // List rooms
          if (!isInRoom)
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(rooms[index]),
                    onTap: () {
                      setState(() {
                        roomName = rooms[index];
                        isInRoom = true;
                      });
                      socket.emit('join_room',
                          {'room': roomName, 'username': username});
                    },
                  );
                },
              ),
            ),
          // Show messages in the current room
          if (isInRoom) ...[
            Text('Room: $roomName'),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
