import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fairbid_rayole_method_channel.dart';

abstract class FairbidRayolePlatform extends PlatformInterface {
  /// Constructs a FairbidRayolePlatform.
  FairbidRayolePlatform() : super(token: _token);

  static final Object _token = Object();

  static FairbidRayolePlatform _instance = MethodChannelFairbidRayole();

  static FairbidRayolePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FairbidRayolePlatform] when
  /// they register themselves.
  static set instance(FairbidRayolePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> initialize({required String fairbidAppId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> loadRewardedAd({required String adId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> showRewardedAd({required String currentRewardedAdId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> setUserId({required String userId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
