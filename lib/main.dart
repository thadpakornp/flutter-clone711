import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THSMS API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'THSMS API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _creditAmount = '0';

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkCredit();
  }

  Future checkCredit() async {
    var url = Uri.parse('https://thsms.com/api/me'); //endpoint, url
    var response = await http.get(url, headers: {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC90aHNtcy5jb21cL21hbmFnZVwvYXBpLWtleSIsImlhdCI6MTY1NzQ3NjY0MSwibmJmIjoxNjc5MTk3NTczLCJqdGkiOiJqck5wQjVGUzRMQ2dNMmR4Iiwic3ViIjoxMDYzMDQsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.8ylK1Iwxe5A_uzkmGbKsvcG0HFmA3r12K2K0IxlIygc',
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      setState(() {
        _creditAmount = data['data']['wallet']['credit'];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

  }

  Future sendSMS() async {
    var url = Uri.parse('https://thsms.com/api/send-sms'); //endpoint, url
    var res = await http.post(url, headers: {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC90aHNtcy5jb21cL21hbmFnZVwvYXBpLWtleSIsImlhdCI6MTY1NzQ3NjY0MSwibmJmIjoxNjc5MTk3NTczLCJqdGkiOiJqck5wQjVGUzRMQ2dNMmR4Iiwic3ViIjoxMDYzMDQsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.8ylK1Iwxe5A_uzkmGbKsvcG0HFmA3r12K2K0IxlIygc',
    }, body: {
      'sender': 'SMS',
      'msisdn': '0974282535',
      'message': 'api',
    });

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print(data);
    } else {
      print('Request failed with status: ${res.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Credit balance: ${_creditAmount}'),
            SizedBox(height: 50),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone number',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Message',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                sendSMS();
              },
              child: Text('Send SMS'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
