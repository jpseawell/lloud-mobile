import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

///
/// I needed to build this small web socket client to work
/// properly with our adonis js framework.
///
/// https://github.com/adonisjs/adonis-websocket-protocol
///

// Web Socket Client (for Adonis JS)
class WsClient {
  final String url;
  String authToken;
  int clientInterval;
  WebSocketChannel channel;
  Timer timer;

  WsClient({this.url, this.authToken});

  WebSocketChannel connect() {
    Map<String, dynamic> headers;

    if (authToken != null) {
      headers = {'Authorization': "Bearer $authToken"};
    }

    channel = IOWebSocketChannel.connect(url, headers: headers);

    return channel;
  }

  void handleEvent(dynamic encodedEvent) {
    Map<String, dynamic> event = json.decode(encodedEvent);
    int eventType = event["t"];

    switch (eventType) {
      case 0: // OPEN
        initPinging(event);
        break;
      default:
    }
  }

  void initPinging(Map<String, dynamic> event) {
    clientInterval = event["d"]["clientInterval"];

    timer = Timer.periodic(new Duration(milliseconds: clientInterval), (timer) {
      ping();
    });
  }

  void join(String topic) {
    send({
      't': 1,
      'd': {'topic': topic}
    });
  }

  void ping() {
    send({
      't': 8,
    });
  }

  void send(Map<String, dynamic> packet) {
    channel.sink.add(jsonEncode(packet));
  }

  void die() {
    channel.sink.close();
    timer.cancel();
  }

  static WsClient create(String url, String authToken) {
    return new WsClient(url: url, authToken: authToken);
  }
}
