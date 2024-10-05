package com.rayole.fairbid.fairbid_rayole;


import androidx.annotation.NonNull;


import android.content.Context;

import com.fyber.FairBid;
import com.fyber.fairbid.ads.ImpressionData;
import com.fyber.fairbid.ads.Rewarded;
import com.fyber.fairbid.ads.rewarded.RewardedListener;
import com.fyber.fairbid.user.UserInfo;

import java.util.Map;
import android.app.Activity;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FairbidRayolePlugin
 */
public class FairbidRayolePlugin implements FlutterPlugin,ActivityAware, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "fairbid_rayole");
        context = flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
    }

    void setAdListener() {
        Rewarded.setRewardedListener(new RewardedListener() {
            @Override
            public void onShow(String placementId, ImpressionData impressionData) {
                // Called when the rewarded ad from placement 'placementId' shows up. In case the ad is a video, audio play will start here.
                channel.invokeMethod("onShow", "");
            }

            @Override
            public void onClick(String placementId) {
                // Called when the rewarded ad from placement 'placementId' is clicked
                channel.invokeMethod("onClick", "");
            }

            @Override
            public void onHide(String placementId) {
                // Called when the rewarded ad from placement 'placementId' hides. In case the ad is a video, audio play will stop here.
                channel.invokeMethod("onHide", "");
            }

            @Override
            public void onShowFailure(String placementId, ImpressionData impressionData) {
                // Called when an error arises when showing the rewarded ad from placement 'placementId'
                channel.invokeMethod("onShowFailure", "");
            }

            @Override
            public void onAvailable(String placementId) {
                // Called when a rewarded ad from placement 'placementId' becomes available
                channel.invokeMethod("onAvailable", "");
            }

            @Override
            public void onUnavailable(String placementId) {
                // Called when a rewarded ad from placement 'placementId' becomes unavailable
                channel.invokeMethod("onUnavailable", "");
            }

            @Override
            public void onCompletion(String placementId, boolean userRewarded) {
                // Called when a rewarded ad from placement 'placementId' finishes playing
                channel.invokeMethod("onCompletion", "");
            }

            @Override
            public void onRequestStart(String placementId, String requestId) {
                // Called when a rewarded ad from placement 'placementId' is going to be requested
                // 'requestId' identifies the request across the whole request/show flow
                channel.invokeMethod("onRequestStart", "");
            }
        });
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "FairbidInitialize": {
                Map<String, String> arguments = call.arguments();
                assert arguments != null;
                String fairbidAppID = arguments.get("FairbidAppID");
                FairBid.start(fairbidAppID, context);
                result.success(true);
                break;
            }
            case "FairbidUserId": {
                Map<String, String> arguments = call.arguments();
                assert arguments != null;
                String userId = arguments.get("userId");
                UserInfo.setUserId(userId);
                result.success(true);
                break;
            }
            case "LoadRewardedAd": {
                setAdListener();
                Map<String, String> arguments = call.arguments();
                assert arguments != null;
                String adId = arguments.get("adId");
                Rewarded.request(adId);
                result.success(true);
                break;
            }
            case "ShowRewardedAd": {
                Map<String, String> arguments = call.arguments();
                assert arguments != null;
                String adId = arguments.get("adId");
                if (Rewarded.isAvailable(adId)) {
                    Rewarded.show(adId, activity);
                }
                result.success(true);
                break;
            }
            default:
                result.success(false);
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    // ActivityAware methods
    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }
}
