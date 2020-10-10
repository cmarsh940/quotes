import 'dart:convert';

import 'package:faithfulQuotes/models/quote.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Faithful Quotes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Quote> parseJosn(String response) {
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Quote>((json) => new Quote.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context).loadString('assets/files/quotes.json'),
            builder: (context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Ops! something went wrong',
                      style: TextStyle(color: Colors.red));
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return new Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    List<Quote> quote = parseJosn(snapshot.data.toString());
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: quote.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('quote: $quote');
                            },
                            child:  Center(
                              child: Text(quote[index].message,
                                  style: new TextStyle(fontSize: 14.0)),
                            ),
                          ),
                        );
                      },
                    );
                  }
              }
              return new Text(
                'Ops! something went wrong',
                style: TextStyle(color: Colors.red),
              );
            }));
  }
}
