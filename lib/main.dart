import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:window_manager/window_manager.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import './warp.dart';
import './WarpData.dart';
import './GetWarpUrl.dart';
import './ParseWarps.dart';

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
  runApp(const MainView());
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Warp> warpList = [];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Segoe UI',
        useMaterial3: false
      ),
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                CupertinoButton(
                  onPressed: () async {
                    _isLoading = true;
                    setState(() {});
                    warpList = await exportWarps(await getWarpUrl('C:\\Star Rail game'));
                    _isLoading = false;
                    setState(() {});
                  },
                  child: Text('Submit'),
                ),
                Container (
                  child: !_isLoading?
                    Flexible (
                      child: DynMouseScroll(
                        animationCurve: Curves.easeOutExpo,
                        scrollSpeed: 1.0,
                        builder:(context, controller, physics) =>  ListView.builder(
                          controller: controller,
                          physics: physics,
                          shrinkWrap: true,
                          itemCount: warpList.length,
                          itemBuilder: (context, index) {
                            return(WarpData(props: warpList[index],));
                          },
                        )
                      )
                    )
                  : Center (
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Colors.blue,),
                        Text('Processing')
                      ],
                    )
                  )
                )
              ]
            ),
          )
        )
      ),
    );
  }
}

class DirSelect extends StatelessWidget {
  const DirSelect ({super.key});

  @override
  Widget build(BuildContext context) {
    return(
      Row(
        children: [

        ],
      )
    );
  }
}