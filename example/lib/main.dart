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
        serverUrl:
        "http://10.130.6.4:8106/sa?project=default",
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
        encrypt: true,
        heatMap: true,
        visualized: VisualizedConfig(autoTrack: true, properties: true),
        android: AndroidConfig(
            maxCacheSize: 48 * 1024 * 1024,
            jellybean: true,
            subProcessFlush: true),
        ios: IOSConfig(maxCacheSize: 10000),
        globalProperties: {'aaa': 'aaa-value', 'bbb': 'bbb-value'});

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
                int? result = await SensorsABTest.fetchCacheABTest("int", 666);
                print("fetchCacheABTest result is===$result");
              },
              child: Text("fetchCacheABTest")),
          TextButton(
              onPressed: () async {
                Map<String, dynamic>? result =
                    await SensorsABTest.fetchABTest("int", {}, 3111);
                print("fetchABTest result is===$result");
              },
              child: Text("fetchABTest")),
          TextButton(
              onPressed: () async {
                String? result =
                    await SensorsABTest.fastFetchABTest<String>("param_cat", "should_be_a_cat");
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
                SensorsABTest.startWithConfigOptions("http://abtesting.saas.debugbox.sensorsdata.cn/api/v2/abtest/online/results?project-key=438B9364C98D54371751BA82F6484A1A03A5155E");
                print("startWithConfigOptions=====");
              },
              child: Text("startWithConfigOptions")),
        ])),
      ),
    );
  }
}

class Student {
  String name = "sss";
  int age = 10;
}
