import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:window_manager/window_manager.dart';

import './warp.dart';
import './warpData.dart';
import './getWarpUrl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Size(480, 800),
    skipTaskbar: false
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  List<Warp> warpList = [];

  final int _page = 1;
  final int _size = 5;
  final int _gachaType = 11;
  final int _endId = 0;

  Future<Map> fetchJson(String query) async {
    print('netreq sent');
    http.Response response;
    try {
      response = await http.get(Uri.parse(query));
    } catch (err) {
      throw Exception('NetRequest failed');
    }
    return convert.jsonDecode(response.body) as Map;
  }

  List<Warp> parseWarp(Map json) {
    print('json parsing');
    List<Warp> l = [];
    for(int i=0; i<(json['data']['list'].length as int); i++) {
      l.add(Warp.fromJson(json['data']['list'][i] as Map));
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Segoe UI'
      ),
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
          child: Column(
              children: [
                CupertinoButton(
                  onPressed: () async {
                    warpList = parseWarp(await fetchJson('${await getWarpUrl('C:\\Star Rail game')}&page=$_page&size=$_size&gacha_type=$_gachaType&end_id=$_endId'));
                    setState(() {});
                  },
                  child: Text('Submit'),
                ),
                ListView(
                  shrinkWrap: true,
                  children: warpList.map((item) => WarpData(props: item)).toList(),
                )
            ]),
          )
        )
      ),
    );
  }
}