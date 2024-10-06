
import 'package:flutter/services.dart';

import 'fairbid_rayole_platform_interface.dart';

List<String> _rewardedAdUnitIds = [];
String _currentRewardedAdId = '';
int _currentIndex = 0; // variable to track the current index


class FairbidRayole {
  static MethodChannel methodChannel = const MethodChannel('fairbid_rayole');

  static FairbidRayole? _instance;

  static FairbidRayole get instance => _instance ??= FairbidRayole();

  static final FairbidRayolePlatform _platform = FairbidRayolePlatform.instance;

  static Future initialize({required String fairbidAppId}) async{

    _platform.initialize(fairbidAppId: fairbidAppId);
  }

  static Future setUserId({required String userId}) async{
     _platform.setUserId(userId: userId);
  }


  static void loadRewardedAd({required List<String> adIds}) async {
    //initial load
    _rewardedAdUnitIds = adIds;
    if (adIds.isNotEmpty) {
      if (_rewardedAdUnitIds.length == 1) {
        _platform.loadRewardedAd(adId: adIds.first);
      } else {
        if (_currentRewardedAdId.isEmpty) {
          _currentRewardedAdId =
              adIds.first; // on initial it will be empty
        }
        for (String id in adIds) {
          _platform.loadRewardedAd(adId: id);
        }
      }
    }
  }

  static void showRewardedAd() async {
    if (_currentRewardedAdId.isNotEmpty) {
      _platform.showRewardedAd(currentRewardedAdId : _currentRewardedAdId);
      changeCurrentId();
    }
  }

  static void changeCurrentId() {
    try {
      _currentIndex = (_currentIndex + 1) % _rewardedAdUnitIds.length;
      _currentRewardedAdId = _rewardedAdUnitIds[_currentIndex];
    } catch (e) {
      _currentIndex = 0;
      print("Error while changing current id: $e");
      _currentRewardedAdId = _rewardedAdUnitIds[_currentIndex];
      print("Error while changing current id: $e");
    }
  }

  static void setAdListener({
    Function()? onShow,
    Function()? onClick,
    Function()? onHide,
    Function()? onShowFailure,
    Function()? onAvailable,
    Function()? onUnavailable,
    Function()? onCompletion,
    Function()? onRequestStart,
  }) {
    methodChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'onShow':
          if (onShow != null) onShow();
          break;
        case 'onClick':
          if (onClick != null) onClick();
          break;
        case 'onHide':
          if (onHide != null) onHide();
          break;
        case 'onShowFailure':
          loadRewardedAd(adIds: [call.arguments]);
          if (onShowFailure != null) onShowFailure();
          break;
        case 'onAvailable':
          if (onAvailable != null) onAvailable();
          break;
        case 'onUnavailable':
          loadRewardedAd(adIds: [call.arguments]);
          if (onUnavailable != null) onUnavailable();
          break;
        case 'onCompletion':
          if (onCompletion != null) onCompletion();
          break;
        case 'onRequestStart':
          if (onRequestStart != null) onRequestStart();
          break;
        default:
          break;
      }
    });
  }
}
