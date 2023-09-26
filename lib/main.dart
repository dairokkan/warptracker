import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:window_manager/window_manager.dart';

import './warp.dart';
import './warpData.dart';

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

  final String _url = 'https://api-os-takumi.mihoyo.com/common/gacha_record/api/getGachaLog?authkey_ver=1&sign_type=2&auth_appid=webview_gacha&win_mode=fullscreen&gacha_id=3580c97631ce2948375a35fd6bec0d8d8806bc&timestamp=1695108112&region=prod_official_eur&default_gacha_type=11&lang=en&authkey=Hpl34Zyx3%2BAVkOO1wGh9qC5TO8dHbqb6BiPZquO5GXmaWahUKTtBjYyfPzbFhLIBp1MX8zWORUy6QnojX7uMDGoHVCrfm5uL9GEmXHTvLithVnGDFT3R26jbDQTz%2BEulRn06pNEThr6CARGkTf3ZSa8rfnk0C0keGJU3EY1zFcc6KriswgRX9gPSAluUDe1ypPrvRQd3BzpsGILff%2Fw%2Buux8TaUPRETPNA95K5GEgJ2Cckduw5zGLGXGRhy1z3OgENvAJ9lHmDFx1xtxf4ONOt5eswviZ3i7j3IK7CxCaiBKkCMXTlsBrOu%2Fbew4buFt2OyBmXMqtBiyt5H4Mi%2FlElXAp7hYBBRGd11bnLwMQzODeblcGC8Jzscaesg5a%2BcjlP4v%2FTSlV9wlc3oPx3Zcx3HVX3Oe9QxAUk3UPMz5AjRe3lw11y2jdWeCgY%2FudltvaVsfkwvMKa2EGMbQK0FoKLlgpdYPWCX%2Fg3RqH%2F0sORZUZ1EhcuuRsmcXhlJOIhLlFSjifpechY%2Bwe%2B1N1eRPzlQ561LFtnKCNp72ZGrjziUn2OAnJkThvVlJb3Egl0eyjpIornW59CvcezG9Kp%2Bi9Lw87EWoSLxxISQn9JNJsTkJ84Iosh8VrpTOp3v17aLOpHJk0%2FARdBcZCFSSBL6yIYd5j3XgqI3yid5ceYiy35A%3D&game_biz=hkrpg_global&os_system=Windows%2010%20%20%2810.0.19045%29%2064bit&device_model=ROG%20Zephyrus%20G14%20GA402RJ_GA402RJZ%20%28ASUSTeK%20COMPUTER%20INC.%29&plat_type=pc&page=1&size=5&gacha_type=11&end_id=0';

  Future<Map> fetchJson(String query) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(query));
    } catch (err) {
      throw Exception('NetRequest failed');
    }
    return convert.jsonDecode(response.body);
  }

  Warp parseWarp(Map json, int item) {
    if(json['retcode']==0) {
      return Warp.fromJson(json['data']['list'][item]);
    } else {
      throw Exception('Invalid link');
    }
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
                    for(int i=0; i<5; i++) {
                      warpList.add(parseWarp(await fetchJson(_url), i));
                    }
;                    setState(() {});
                  },
                  child: Text('Submit'),
                ),
                Column(children: warpList.map((item) => WarpData(props: item)).toList(),)
            ]),
          )
        )
      ),
    );
  }
}