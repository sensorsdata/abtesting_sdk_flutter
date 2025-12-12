import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

/// A/B Testing 试验参数配置
class SensorsABTestExperiment {
  /// --- 只读字段 ---
  final String paramName;
  final dynamic defaultValue;

  /// --- 可读写字段 ---
  Map<String, dynamic>? properties;
  double timeoutInterval;

  /// 默认超时时间（Flutter 中，毫秒单位）
  static const double defaultTimeoutInterval = 30 * 1000;

  /// 禁止使用默认构造方法
  SensorsABTestExperiment._({
    required this.paramName,
    required this.defaultValue,
    this.properties,
    double? timeoutInterval,
  }) : timeoutInterval = timeoutInterval ?? defaultTimeoutInterval;

  /// 指定构造方法 —— 对应 initWithParamName:defaultValue:
  factory SensorsABTestExperiment({
    required String paramName,
    required dynamic defaultValue,
    Map<String, dynamic>? properties,
    double? timeoutInterval,
  }) {
    return SensorsABTestExperiment._(
      paramName: paramName,
      defaultValue: defaultValue,
      properties: properties,
      timeoutInterval: timeoutInterval,
    );
  }

  /// 工厂方法 —— 对应 +experimentWithParamName:defaultValue:
  factory SensorsABTestExperiment.experimentWithParamName(
    String paramName,
    dynamic defaultValue,
  ) {
    return SensorsABTestExperiment._(
      paramName: paramName,
      defaultValue: defaultValue,
    );
  }

  /// 转成 Map
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "paramName": paramName,
      "defaultValue": defaultValue,
      "timeoutInterval": timeoutInterval,
    };

    if (properties != null) {
      map["properties"] = properties;
    }

    return map;
  }
}

class SensorsABTest {
  static const MethodChannel _channel = const MethodChannel('sa_abtesting_sdk');
  static const int TIMEOUT_REQUEST = 30 * 1000;

  ///初始化 A/B Testing，在此之前请确保先初始化神策分析 SDK：
  ///[Android 参考文档](https://manual.sensorsdata.cn/sa/latest/tech_sdk_client_android_basic-17563982.html)，
  ///[iOS 参考文档](https://manual.sensorsdata.cn/sa/latest/tech_sdk_client_ios_use-27724338.html)。
  ///[urlString] 分流地址 url
  ///[customProperties] 自定义属性，可选
  static void startWithConfigOptions(
    String urlString, [
    Map<String, dynamic>? customProperties,
  ]) {
    final params = {
      "urlString": urlString,
      "customProperties": customProperties,
    };
    _channel.invokeMethod("startWithConfigOptions", params);
  }

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

  /// 如果本地有缓存，则返回缓存数据；否则从网络请求最新的试验数据，默认 30s 超时时间。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型，
  /// [timeoutMillSeconds] 的值默认是 30  * 1000，单位是 ms。
  static Future<T?> fastFetchABTest<T>(String paramName, T defaultValue,
      [int timeoutMillSeconds = TIMEOUT_REQUEST]) async {
    if (defaultValue is Map) {
      dynamic result = await _channel.invokeMethod(
          "fastFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod(
        "fastFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
  }

  /// 始终从网络请求试验结果，默认 30s 超时时间。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型，
  /// [timeoutMillSeconds] 的值默认是 30  * 1000，单位是 ms。
  static Future<T?> asyncFetchABTest<T>(String paramName, T defaultValue,
      [int timeoutMillSeconds = TIMEOUT_REQUEST]) async {
    if (defaultValue is Map) {
      dynamic result = await _channel.invokeMethod(
          "asyncFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod(
        "asyncFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
  }

  /// 如果本地有缓存，则返回缓存数据；否则从网络请求最新的试验数据，默认 30s 超时时间。
  /// [experiment] 是试验参数配置对象，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型。
  static Future<T?> fastFetchABTestWithExperiment<T>(
      SensorsABTestExperiment experiment) async {
    dynamic map = experiment.toMap();

    if (experiment.defaultValue is Map) {
      dynamic result =
          await _channel.invokeMethod("fastFetchABTestWithExperiment", [map]);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod("fastFetchABTestWithExperiment", [map]);
  }

  /// 始终从网络请求试验结果，默认 30s 超时时间。
  /// [experiment] 是试验参数配置对象，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型。
  static Future<T?> asyncFetchABTestWithExperiment<T>(
      SensorsABTestExperiment experiment) async {
    dynamic map = experiment.toMap();

    if (experiment.defaultValue is Map) {
      dynamic result =
          await _channel.invokeMethod("asyncFetchABTestWithExperiment", [map]);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod("asyncFetchABTestWithExperiment", [map]);
  }

/**
 * 设置获取试验时的自定义主体 ID，全局有效
 * [customIDs] 自定义主体 ID
 */
  static void setCustomIDs(Map<String, String> customIDs) {
    _channel.invokeMethod("setCustomIDs", customIDs);
  }

  /**
 * 设置自定义属性
 * 设置多次时，以最后设置为准，会直接覆盖前次设置内容
 * 设置自定义属性，下次 SDK 初始化后重置
 * [customProperties] 设置的自定义属性内容
 */
  static void setCustomProperties(Map<String, dynamic> customProperties) {
    _channel.invokeMethod("setCustomProperties", customProperties);
  }

  /// --- 已废弃方法，请使用 asyncFetchABTest ---
  /// 始终从网络请求试验结果，默认 30s 超时时间。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型，
  /// [timeoutMillSeconds] 的值默认是 30  * 1000，单位是 ms。
  @Deprecated(
      'Please use the asyncFetchABTest interface, It has the same functionality.')
  static Future<T?> fetchABTest<T>(String paramName, T defaultValue,
      [int timeoutMillSeconds = TIMEOUT_REQUEST]) async {
    if (defaultValue is Map) {
      dynamic result = await _channel.invokeMethod(
          "asyncFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod(
        "asyncFetchABTest", [paramName, defaultValue, timeoutMillSeconds]);
  }
}
