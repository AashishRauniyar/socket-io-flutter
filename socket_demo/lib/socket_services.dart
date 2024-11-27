import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  IO.Socket? socket;

  SocketService._internal();

  Function(dynamic data)? onLoginEvent;
  Function(dynamic data)? onLogoutEvent;

  factory SocketService() {
    return _instance;
  }

  void connectAndListen() {
    socket ??= IO.io('http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket?.onConnect(
      (data) {
        print('connect');
      },
    );

    socket?.on('session-expired', (data) {
      print('session-expired');
      onLogoutEvent?.call(data);
    });

    socket?.on('session-join', (data) {
      onLoginEvent?.call(data);
    });
  }

  void joinSession(String sessionId) {
    socket?.emit('user-join', sessionId);
  }

  void dispose() {
    if (socket != null) {
      socket?.disconnect();
      socket = null;
    }
  }
}
