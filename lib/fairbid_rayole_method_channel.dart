import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fairbid_rayole_platform_interface.dart';

/// An implementation of [FairbidRayolePlatform] that uses method channels.
class MethodChannelFairbidRayole extends FairbidRayolePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fairbid_rayole');



  @override
  Future<bool?> initialize({required String fairbidAppId}) async {
    final version = await methodChannel.invokeMethod("FairbidInitialize",{'FairbidAppID': fairbidAppId});
    return version;
  }

  @override
  Future<bool?> loadRewardedAd({required String adId}) async {
    final version = await methodChannel.invokeMethod("LoadRewardedAd",{'adId': adId});
    return version;
  }

  @override
  Future<bool?> showRewardedAd({required String currentRewardedAdId}) async {
    final version = await methodChannel.invokeMethod("ShowRewardedAd",{'adId': currentRewardedAdId});
    return version;
  }

  @override
  Future<bool?> setUserId({required String userId}) async {
    final version = await methodChannel.invokeMethod("FairbidUserId",{'userId': userId});
    return version;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
