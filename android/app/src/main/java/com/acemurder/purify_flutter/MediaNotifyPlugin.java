package com.acemurder.purify_flutter;

import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * Created by ：AceMurder
 * Created on ：2019/3/11
 * Created for : android.
 * Enjoy it !!!
 */
public class MediaNotifyPlugin implements MethodChannel.MethodCallHandler {
    private static final String TAG = "MediaNotifyPlugin";

    public static final String CHANNEL_NAME = "purify_flutter/notify_media";
    private final Registrar mRegistrar;

    public MediaNotifyPlugin(Registrar registrar) {
        mRegistrar = registrar;
    }


    public static void registerWith(PluginRegistry.Registrar registrar) {
        MethodChannel channel =
                new MethodChannel(registrar.messenger(), CHANNEL_NAME);
        MediaNotifyPlugin instance = new MediaNotifyPlugin(registrar);
        channel.setMethodCallHandler(instance);
    }

    public static boolean alreadyRegisteredWith(PluginRegistry registry) {
        final String key = MediaNotifyPlugin.class.getCanonicalName();
        if (registry.hasPlugin(key)) {
            return true;
        }
        registry.registrarFor(key);
        return false;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        Log.d(TAG, "onMethodCall");
        if (methodCall.method.equals("mediaScan")) {
            String path = methodCall.argument("path");
            if (TextUtils.isEmpty(path)) {
                Log.d(TAG, "path is null");
                result.error("path is null", "path is nul", null);
                return;
            }
            Log.d(TAG, "path is " + path);
            Uri contentUri = Uri.fromFile(new File(path));
            Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, contentUri);
            mRegistrar.activity().sendBroadcast(mediaScanIntent);
            result.success(null);
        } else {
            result.notImplemented();
        }

    }
}
