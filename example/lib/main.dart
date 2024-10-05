import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fairbid_rayole/fairbid_rayole.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _fairbidRayolePlugin = FairbidRayole();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    FairbidRayole().initialize(fairbidAppId: '175974');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                    FairbidRayole.loadRewardedAd(
                        adIds: ["1920945", "1920947", "1920950"]);
                    print("ad loading started");
                    FairbidRayole.setAdListener(onClick: () {
                      print("Ad onClick!!! ");
                    }, onHide: () {
                      print("Ad onHide!!! ");
                    }, onShowFailure: () {
                      print("Ad onShowFailure!!! ");
                    }, onAvailable: () {
                      print("Ad onAvailable!!! ");
                    }, onUnavailable: () {
                      print("Ad onUnavailable!!! ");
                    }, onCompletion: () {
                      print("Ad onCompletion!!! ");
                    }, onRequestStart: () {
                      print("Ad onRequestStart!!! ");
                    });
                  },
                  child: const SizedBox(height: 50, child: Text('load'))),
              InkWell(
                  onTap: () {
                    FairbidRayole.showRewardedAd();
                  },
                  child: SizedBox(height: 50, child: Text('Show ad'))),
            ],
          ),
        ),
      ),
    );
  }
}
