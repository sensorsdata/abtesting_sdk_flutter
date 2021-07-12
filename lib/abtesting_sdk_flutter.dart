import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class SensorsABTest {
  static const MethodChannel _channel = const MethodChannel('sa_abtesting_sdk');
  static const int TIMEOUT_REQUEST = 30 * 1000;

  // ///初始化 A/B Testing，在此之前请确保先初始化神策分析 SDK [参考文档](https://manual.sensorsdata.cn/sa/latest/tech_sdk_client_android_basic-17563982.html)。
  // ///[url] 为服务器地址
  // static void startWithConfigOptions(String url){
  //   _channel.invokeMethod("startWithConfigOptions", url);
  // }

  /// 从缓存中获取试验结果。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型。
  static Future<T?> fetchCacheABTest<T>(
      String paramName, T defaultValue) async {
    if (defaultValue is Map) {
      dynamic result = await _channel
          .invokeMethod("fetchCacheABTest", [paramName, defaultValue]);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod("fetchCacheABTest", [paramName, defaultValue]);
  }

  /// 始终从网络请求试验结果，默认 30s 超时时间。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型，
  /// [timeoutMillSeconds] 的值默认是 30  * 1000，单位是 ms。
  static Future<T?> fetchABTest<T>(String paramName, T defaultValue,
      [int timeoutMillSeconds = TIMEOUT_REQUEST]) async {
    if (defaultValue is Map) {
      dynamic result = await _channel
          .invokeMethod("asyncFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod("asyncFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
  }

  /// 如果本地有缓存，则返回缓存数据；否则从网络请求最新的试验数据，默认 30s 超时时间。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型，
  /// [timeoutMillSeconds] 的值默认是 30  * 1000，单位是 ms。
  static Future<T?> fastFetchABTest<T>(String paramName, T defaultValue,
      [int timeoutMillSeconds = TIMEOUT_REQUEST]) async {
    if (defaultValue is Map) {
      dynamic result = await _channel
          .invokeMethod("fastFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod("fastFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
  }
}
