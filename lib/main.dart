import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helloworld/constants.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List games = [];

  void fetchGames() async {
    games.clear();
    setState(() {});
    await http
        .get(Uri.parse("https://api.rawg.io/api/games?key=$rawgKey"))
        .then((value) {
      if (value.statusCode == 200) {
        setState(() {
          games = jsonDecode(value.body)["results"];
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Not found')));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Games"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              tileColor: Colors.black26,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(games[index]["background_image"]),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              title: Text(games[index]["name"].toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchGames,
        tooltip: 'Refetch',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
