import 'dart:convert';

import 'package:d_platform_pro_sdk/d_platform_pro_sdk.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = "Unknow";

  @override
  void initState() {
    super.initState();
    DPlatformProSdk.listener((data) {
      print('=================result===========${data.runtimeType}======');
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;
      setState(() {
        result = jsonEncode(data);
        print('=================action===========${data["params"]}======');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('d platform plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text(result),
            RaisedButton(
              onPressed: () {
                DPlatformProSdk.call(
                  scheme: "org.dplatform.game.cs.org.platform.demo.game",
                  action: "login",
                  androidPackageName: "org.dplatform.d_platform_sdk_test",
                  params: {
                    "code": 0,
                    "msg": null,
                    "data": {
                      "token": "tx9091",
                      "userId": "100011",
                      "no": 409,
                    }
                  },
                  downloadUrl: "www.360.com",
                  customFullUri: (s, a, p) {
                    return buildFullUri(
                      scheme: s,
                      action: a,
                      params: p,
                    );
                  },
                );
              },
              child: Text('获取token登录'),
            ),
          ],
        ),
      ),
    );
  }
}

String buildFullUri({
  String scheme,
  String action,
  Map<String, dynamic> params,
}) {
  if (null == scheme) throw Exception("scheme is null!");
  if (null == action) throw Exception("action is null!");
  params?.addAll({"aciton": action});
  return Uri.encodeFull(
      "${scheme.contains("://") ? scheme : "$scheme://do"}?params1=${jsonEncode(params)}");
}
