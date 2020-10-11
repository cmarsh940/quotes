import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:faithfulQuotes/models/quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Faithful Quotes',
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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Random random = new Random();
  Future<DateTime> _setDate;
  int idx = 0;
  Color textColor = Colors.white;
  Color backgroundColor = Colors.black;

  List<Quote> parseJosn(String response) {
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Quote>((json) => new Quote.fromJson(json)).toList();
  }

  void changeIndex() {
    setState(() => idx = random.nextInt(118));
  }

  @override
  void initState() {
    super.initState();
    changeIndex();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeColor(Color color) => setState(() => textColor = color);
  void changeBackgroundColor(Color color) => setState(() => backgroundColor = color);

  Future _settingsSheet(BuildContext context) async {
    return await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Settings',
                  style: TextStyle(decoration: TextDecoration.underline),
                  textAlign: TextAlign.center
                ),
                ListTile(
                  title: const Text('Change Background Color'),
                  trailing: Icon(Icons.colorize), //`Icon` to display
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(0.0),
                          contentPadding: const EdgeInsets.all(0.0),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: backgroundColor,
                              onColorChanged: changeBackgroundColor,
                              colorPickerWidth: 300.0,
                              pickerAreaHeightPercent: 0.7,
                              enableAlpha: true,
                              displayThumbColor: true,
                              showLabel: true,
                              paletteType: PaletteType.hsv,
                              pickerAreaBorderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  },
                ),
                ListTile(
                  title: const Text('Change Text Color'),
                  trailing: Icon(Icons.colorize), //`Icon` to display
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(0.0),
                          contentPadding: const EdgeInsets.all(0.0),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: textColor,
                              onColorChanged: changeColor,
                              colorPickerWidth: 300.0,
                              pickerAreaHeightPercent: 0.7,
                              enableAlpha: true,
                              displayThumbColor: true,
                              showLabel: true,
                              paletteType: PaletteType.hsv,
                              pickerAreaBorderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  },
                ),
              ],
            ),
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString('assets/files/quotes.json'),
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
                  List<Quote> quotes = parseJosn(snapshot.data.toString());
                  print('quotes length: ${quotes.length}');
                  return Container(
                    decoration: BoxDecoration(
                      color: backgroundColor
                      // image: DecorationImage(
                      //   image: NetworkImage(
                      //       'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          quotes[idx].message,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 40,
                            color: textColor,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none
                          ),
                        ),
                        SizedBox(height: 20),
                        AutoSizeText(
                          "- ${quotes[idx].person}",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            color: textColor,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none
                          ),
                        ),
                      ],
                    ),
                  );
                }
            }
            return new Text(
              'Ops! something went wrong',
              style: TextStyle(color: Colors.red),
            );
          },
        ),
      ),
      Positioned(
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _settingsSheet(context);
              },
              tooltip: 'Share',
            ),
          ],
        ),
      ),
    ]));
  }
}
