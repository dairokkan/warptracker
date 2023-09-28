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

  static int _page = 0;
  static final int _size = 5;
  static final int _gachaType = 11;
  static int _endId = 0;

  String generateURL(String url) {
    print('generating url');
    _page++;
    _endId = (warpList.length==0)?0:warpList[warpList.length-1].id;
    return('$url&page=$_page&size=$_size&gacha_type=$_gachaType&end_id=$_endId');
  }

  Future<Map> fetchJson(String query) async {
    print('netreq sent');
    http.Response response;
    try {
      response = await http.get(Uri.parse(query));
    } catch (err) {
      throw Exception('NetRequest failed');
    }
    return convert.jsonDecode(response.body);
  }

  List<Warp> parseWarp(Map json) {
    print('json parsing');
    List<Warp> l = [];
    for(int i=0; i<(json['data']['list'].length); i++) {
      l.add(Warp.fromJson(json['data']['list'][i]));
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
                    _page=0;
                    warpList=[];
                    final String url = await getWarpUrl('C:\\Star Rail game');
                    for(int i=0; i<5; i++){
                      warpList.addAll(parseWarp(await fetchJson(generateURL(url))));
                    }
                    setState(() {});
                  },
                  child: Text('Submit'),
                ),
                ListView(
                  shrinkWrap: true,
                  children: warpList.map((item) => WarpData(props: item)).toList(),
                )
              ]
            ),
          )
        )
      ),
    );
  }
}