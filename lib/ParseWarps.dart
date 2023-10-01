import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import './warp.dart';
import './main.dart';
import './ThrowError.dart';

bool isFinished = false;

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
    throwError(scaffoldKey, 'Failed to send net request');
    throw Exception();
  }
  return convert.jsonDecode(response.body);
}

List<Warp> parseWarp(Map json) {
  print('json parsing');
  List<Warp> l = [];
  if(json['data']['list'].length==0){
    print('terminated');
    isFinished=true;
    return [];
  } else {
    for(int i=0; i<(json['data']['list'].length); i++) {
      l.add(Warp.fromJson(json['data']['list'][i]));
    }
  }
  
  return l;
}

Future<List<Warp>> exportWarps(String url, int size, int gachaType) async {
  int endId = 0;
  List<Warp> l = [];
  isFinished = false;

  for(int i = 1; isFinished==false; i++) {
    l.addAll(parseWarp(await fetchJson(generateURL(url, i, endId, gachaType, size))));
    endId = l[l.length-1].id;
  }

  return l;
}