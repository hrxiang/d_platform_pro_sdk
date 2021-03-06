package org.dplatform.d_platform_pro_sdk;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;

import org.dplatform.d_platform_pro_sdk.utils.Utils;
import org.dplatform.d_platform_pro_sdk.utils.WithParameter;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry;

/**
 * DPlatformProSdkPlugin
 */
public class DPlatformProSdkPlugin implements MethodCallHandler, PluginRegistry.NewIntentListener {
    private Activity activity;
    private static MethodChannel channel;

    private DPlatformProSdkPlugin(Activity activity) {
        this.activity = activity;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        try {
            if ("call".equals(methodCall.method)) {
                if (methodCall.arguments() instanceof Map) {
                    String uriStr = methodCall.argument("uri");
                    String packageName = methodCall.argument("androidPackageName");
                    String downloadUrl = methodCall.argument("downloadUrl");
                    if (null != uriStr) {
                        Uri uri = Uri.parse(uriStr);
                        if (null != packageName) {
                            boolean isInstalled = Utils.isInstalled(activity, packageName);
                            if (isInstalled) {
                                call(activity, uri);
                            } else {
                                if (null != downloadUrl) {
                                    Utils.openBrowser(activity, downloadUrl);
                                }
                            }
                        } else {
                            try {
                                call(activity, uri);
                            } catch (Exception e) {
                                e.printStackTrace();
                                if (e instanceof ActivityNotFoundException && null != downloadUrl) {
                                    Utils.openBrowser(activity, downloadUrl);
                                }
                            }
                        }
                    }
                }
            } else if ("listener".equals(methodCall.method)) {
                System.out.println("DPlatformProSdkPlugin============onCreate method===============");
                send(Utils.getUri(activity));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        System.out.println("================DPlatformProSdkPlugin register===============");
        DPlatformProSdkPlugin plugin = new DPlatformProSdkPlugin(registrar.activity());
        // 注册onNewIntent
        registrar.addNewIntentListener(plugin);
        // 创建通道
        channel = new MethodChannel(registrar.messenger(), "d_platform_pro_sdk");
        channel.setMethodCallHandler(plugin);
    }

    @Override
    public boolean onNewIntent(Intent intent) {
        System.out.println("DPlatformProSdkPlugin============onNewIntent method===============");
        send(Utils.getUri(intent));
        return false;
    }

    private static void send(Uri uri) {
        if (null != uri) {
            System.out.println("DPlatformProSdkPlugin===========parse=================" + Uri.decode(uri.toString()));
            Set<String> keys = uri.getQueryParameterNames();
            Map<String, String> arguments = new HashMap<>();
            if (null != keys) {
                String value;
                for (String key : keys) {
                    value = uri.getQueryParameter(key);
                    if (null != value) {
                        arguments.put(key, value);
                    }
                }
            }
            channel.invokeMethod("listener", arguments);
        }
    }

    private static void call(Activity activity, Uri uri) {
        Utils.call(activity, uri, new WithParameter() {
            @Override
            public void with(Intent intent) {
                intent.setAction(Intent.ACTION_VIEW);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            }
        });
    }
}
