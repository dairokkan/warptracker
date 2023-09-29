import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:window_manager/window_manager.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:file_picker/file_picker.dart';

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
  String _dir = 'C:\\Program Files\\Star Rail\\Star Rail game';

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
                Row (
                  children: [
                    Expanded(child:
                      Text(_dir),
                    ),
                    CupertinoButton(child: Icon(Icons.folder_outlined), onPressed: () async {
                      _dir = await FilePicker.platform.getDirectoryPath() as String;
                      setState(() {});
                    }),
                    CupertinoButton(child: Icon(Icons.refresh), onPressed: () async {
                      _isLoading=true;
                      setState(() {});
                      warpList = await exportWarps(await getWarpUrl(_dir), 5, 11);
                      _isLoading = false;
                      setState(() {});
                    },)
                  ],
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
                  : Column(
                      children: [
                        CircularProgressIndicator(color: Colors.blue,),
                        Text('Processing')
                      ],
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