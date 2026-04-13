import 'package:flutter/material.dart';
import 'screen/homeScreen.dart';
import 'screen/recipeScreen.dart';
import 'screen/detailRecipe.dart';
import 'screen/detailReport.dart';
import 'screen/trendScreen.dart';
import 'screen/alarmScreen.dart';
import 'screen/reportScreen.dart';
import 'screen/loginScreen.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/homeScreen': (context) => HomeScreen(),
        '/recipeScreen': (context) => RecipeScreen(),
        '/detailRecipe': (context) => DetailRecipe(),
        '/trendScreen': (context) => TrendScreen(),
        '/alarmScreen': (context) => AlarmScreen(),
        '/reportScreen': (context) => ReportScreen(),
        '/detailReport': (context) => DetailReport(),
      },
      home: HomeScreen(),
      // Scaffold(
      //   appBar: AppBar(title: Text('WebSocket Demo')),
      //   body: WebSocketDemo(),
      // ),
    );
  }
}

class WebSocketDemo extends StatefulWidget {
  final WebSocketChannel channel = IOWebSocketChannel.connect(
    'wss://echo.websocket.org',
  );

  @override
  State<WebSocketDemo> createState() => _WebSocketDemoState(channel: channel);
}

final TextEditingController _controller = TextEditingController();
List<String> _messages = [];

class _WebSocketDemoState extends State<WebSocketDemo> {
  final WebSocketChannel channel;

  _WebSocketDemoState({required this.channel}) {
    channel.stream.listen((data) {
      setState(() {
        _messages.add(data);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                      labelText: 'Message',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        print('Sending: ${_controller.text}');
                        channel.sink.add(_controller.text);
                        _controller.clear();
                      }
                    },
                    child: Text('Send'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: getMessageList()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    channel.sink.close();
    super.dispose();
  }
}

ListView getMessageList() {
  List<Widget> listWidgets = [];
  for (String message in _messages) {
    listWidgets.add(
      ListTile(
        title: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(message, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
  return ListView(children: listWidgets);
}
