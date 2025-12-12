import 'package:abtesting_sdk_flutter/abtesting_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    SensorsAnalyticsFlutterPlugin.init(
        serverUrl: "http://10.130.6.4:8106/sa?project=default",
        autoTrackTypes: <SAAutoTrackType>{
          SAAutoTrackType.APP_START,
          SAAutoTrackType.APP_VIEW_SCREEN,
          SAAutoTrackType.APP_CLICK,
          SAAutoTrackType.APP_END
        },
        networkTypes: <SANetworkType>{
          SANetworkType.TYPE_2G,
          SANetworkType.TYPE_3G,
          SANetworkType.TYPE_4G,
          SANetworkType.TYPE_WIFI,
          SANetworkType.TYPE_5G
        },
        flushInterval: 30000,
        flushBulkSize: 150,
        enableLog: true,
        javaScriptBridge: true,
        // encrypt: true,
        // heatMap: true,
        // visualized: VisualizedConfig(autoTrack: true, properties: true),
        android: AndroidConfig(
            maxCacheSize: 48 * 1024 * 1024,
            jellybean: true,
            subProcessFlush: true),
        ios: IOSConfig(maxCacheSize: 10000),
        globalProperties: {'aaa': 'flutter 全局属性', 'bbb': 'flutter 全局属性-2'});

// 注册公共属性
    // final anonymousId = SensorsAnalyticsFlutterPlugin.getAnonymousId();
    // SensorsAnalyticsFlutterPlugin.registerSuperProperties(
    //     {'anonymous_id': anonymousId});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(children: [
          Text('Running on: $_platformVersion\n'),
          TextButton(
              onPressed: () async {
                // 旧测试分流地址：http://abtesting.saas.debugbox.sensorsdata.cn/api/v2/abtest/online/results?project-key=438B9364C98D54371751BA82F6484A1A03A5155E
                SensorsABTest.startWithConfigOptions(
                    "http://abtesting.saas.debugbox.sensorsdata.cn/api/v2/abtest/online/results?project-key=438B9364C98D54371751BA82F6484A1A03A5155E");
                print("startWithConfigOptions=====");
              },
              child: Text("startWithConfigOptions")),
          TextButton(
              onPressed: () async {
                var map = {"address": "beijing"};
                SensorsABTest.startWithConfigOptions(
                    "http://abtesting.saas.debugbox.sensorsdata.cn/api/v2/abtest/online/results?project-key=438B9364C98D54371751BA82F6484A1A03A5155E",
                    map);
                print("startWithConfigOptions customProperties=====");
              },
              child: Text("startWithConfigOptions-customProperties")),
          TextButton(
              onPressed: () async {
                int? result =
                    await SensorsABTest.fetchCacheABTest("index_cqs", 666);
                print("fetchCacheABTest result is===$result");
              },
              child: Text("fetchCacheABTest")),
          TextButton(
              onPressed: () async {
                Map<String, dynamic>? result =
                    await SensorsABTest.asyncFetchABTest("json_cqs", {});
                print("asyncFetchABTest result is===$result");
              },
              child: Text("asyncFetchABTest")),
          TextButton(
              onPressed: () async {
                String? result = await SensorsABTest.fastFetchABTest<String>(
                    "color_cqs", "字符串默认值");
                print("fastFetchABTest result is===$result");
              },
              child: Text("fastFetchABTest")),
          TextButton(
              onPressed: () async {
                SensorsAnalyticsFlutterPlugin.login("xiaoming-123123");
                print("login=====");
              },
              child: Text("login")),
          TextButton(
              onPressed: () async {
                var experiment =
                    SensorsABTestExperiment.experimentWithParamName(
                        "cqs_city1", "cqs_city 默认值");
                // 设置自定义属性
                experiment.properties = {"\$city": "合肥"};
                experiment.timeoutInterval = 20 * 1000;
                SensorsABTest.fastFetchABTestWithExperiment<String>(experiment)
                    .then((value) {
                  print("fastFetchABTestWithExperiment result is===$value");
                });
              },
              child: Text("fastFetchABTestWithExperiment")),
          TextButton(
              onPressed: () async {
                // 不设置自定义属性
                var experiment =
                    SensorsABTestExperiment.experimentWithParamName(
                        "cqs_city", "cqs_city 默认值");
                experiment.timeoutInterval = 20 * 1000;
                SensorsABTest.asyncFetchABTestWithExperiment<String>(experiment)
                    .then((value) {
                  print("asyncFetchABTestWithExperiment result is===$value");
                });
              },
              child: Text("asyncFetchABTestWithExperiment")),
          TextButton(
              onPressed: () async {
                // 设置自定义主体
                SensorsABTest.setCustomIDs({"custom_id_1": "custom_value_1"});
              },
              child: Text("setCustomIDs")),
          TextButton(
              onPressed: () async {
                // 设置自定义主体
                SensorsABTest.setCustomProperties(
                    {"custom_properties_1": "custom_value_1"});
              },
              child: Text("setCustomProperties")),
        ])),
      ),
    );
  }
}

class Student {
  String name = "sss";
  int age = 10;
}
