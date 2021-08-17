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
                Map<String, dynamic>? result =
                    await SensorsABTest.fastFetchABTest("int", {});
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
