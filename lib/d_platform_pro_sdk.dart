import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DPlatformProSdk {
  static const MethodChannel _channel =
      const MethodChannel('d_platform_pro_sdk');

  /// 其他app唤起当前app传递数据
  static void listener(handler(dynamic arguments)) {
    _channel.setMethodCallHandler((MethodCall call) {
      if ("listener" == call.method && null != handler) {
        return handler(call.arguments);
      }
      return null;
    });
    // 首次启动app
    _channel.invokeMethod("listener");
  }

  /// 当前唤起其他app获取数据
  static void call({
    @required String scheme,
    @required String action,
    String androidPackageName,
    String iosBundleId,
    String downloadUrl,
    Map<String, dynamic> params = const <String, dynamic>{},
    CustomFullUri customFullUri,
  }) async {
    _channel.invokeMethod("call", {
      "uri": null != customFullUri
          ? customFullUri(scheme, action, params)
          : buildFullUri(scheme: scheme, action: action, params: params),
      // 被唤起的应用的scheme
      "action": action,
      // 事件类型
      "androidPackageName": androidPackageName,
      // 被唤起的应用的包名
      "iosBundleId": iosBundleId,
      // 被唤起的应用的包名
      "downloadUrl": downloadUrl,
      // 被唤起的应用的下载地址
    });
  }
}

typedef CustomFullUri = String Function(
  String scheme,
  String action,
  Map<String, dynamic> params,
);

String buildFullUri({
  String scheme,
  String action,
  Map<String, dynamic> params,
}) {
  if (null == scheme) throw Exception("scheme is null!");
  if (null == action) throw Exception("action is null!");
  params?.addAll({"action": action});
  return Uri.encodeFull(
      "${scheme.contains("://") ? scheme : "$scheme://do"}?commonSdkParams=${jsonEncode(params)}");
}
