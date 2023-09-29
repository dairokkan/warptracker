import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import './warp.dart';

String generateURL(String url, int page, int endId, int gachaType, int size) {
  print('generating url');
  return('$url&page=$page&size=$size&gacha_type=$gachaType&end_id=$endId');
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

Future<List<Warp>> exportWarps(String url) async {
  final int _size = 5;
  final int _gachaType = 11;
  int _endId = 0;
  List<Warp> l = [];

  for(int i = 1; i<=5; i++) {
    l.addAll(parseWarp(await fetchJson(generateURL(url, i, _endId, _gachaType, _size))));
    _endId = l[l.length-1].id;
  }

  return l;
}