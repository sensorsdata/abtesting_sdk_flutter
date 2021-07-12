package com.sensorsdata.analytics.abtesting.abtesting_sdk_flutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.sensorsdata.abtest.OnABTestReceivedData;
import com.sensorsdata.abtest.SensorsABTest;
import com.sensorsdata.abtest.SensorsABTestConfigOptions;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AbtestingSdkFlutterPlugin */
public class AbtestingSdkFlutterPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context applicationContext;
    private Handler uiThreadHandler = new Handler(Looper.getMainLooper());

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sa_abtesting_sdk");
        channel.setMethodCallHandler(this);
        applicationContext = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        String method = call.method;
        switch (method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "startWithConfigOptions":
                startWithConfigOptions(call, result);
                break;
            case "fetchCacheABTest":
                fetchCacheABTest(call, result);
                break;
            case "asyncFetchABTest":
                asyncFetchABTest(call, result);
                break;
            case "fastFetchABTest":
                fastFetchABTest(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void startWithConfigOptions(MethodCall call, Result result) {
        String url = (String) call.arguments;
        SensorsABTestConfigOptions abTestConfigOptions = new SensorsABTestConfigOptions(url);
        SensorsABTest.startWithConfigOptions(applicationContext, abTestConfigOptions);
        result.success(null);
    }

    private void fetchCacheABTest(MethodCall call, Result result) {
        List list = (List) call.arguments;
        String paramName = (String) list.get(0);
        Object defaultValue = list.get(1);
        if (defaultValue instanceof Map) {
            defaultValue = new JSONObject((Map) defaultValue);
        }
        Object abResult = SensorsABTest.shareInstance().fetchCacheABTest(paramName, defaultValue);
        checkResult(abResult, result);
    }

    private void asyncFetchABTest(MethodCall call, final Result result) {
        List list = (List) call.arguments;
        String paramName = (String) list.get(0);
        Object defaultValue = list.get(1);
        int timeout = (int) list.get(2);
        if (defaultValue instanceof Map) {
            defaultValue = new JSONObject((Map) defaultValue);
        }
        SensorsABTest.shareInstance().asyncFetchABTest(paramName, defaultValue, timeout, new OnABTestReceivedData() {
            @Override
            public void onResult(final Object value) {
                uiThreadHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        checkResult(value, result);
                    }
                });
            }
        });
    }

    private void fastFetchABTest(MethodCall call, final Result result) {
        List list = (List) call.arguments;
        String paramName = (String) list.get(0);
        Object defaultValue = list.get(1);
        int timeout = (int) list.get(2);
        if (defaultValue instanceof Map) {
            defaultValue = new JSONObject((Map) defaultValue);
        }
        SensorsABTest.shareInstance().fastFetchABTest(paramName, defaultValue, timeout, new OnABTestReceivedData() {
            @Override
            public void onResult(final Object value) {
                uiThreadHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        checkResult(value, result);
                    }
                });
            }
        });
    }

    private void checkResult(Object abResult, Result result) {
        if (abResult instanceof JSONObject) {
            JSONObject jsonObject = (JSONObject) abResult;
            result.success(jsonObject.toString());
            return;
        }
        result.success(abResult);
    }

    private static Map<String, Object> toMap(JSONObject obj) {
        if (obj == null) {
            return null;
        }
        Map<String, Object> data = new HashMap<>();
        Iterator<String> it = obj.keys();
        while (it.hasNext()) {
            String key = it.next();
            data.put(key, obj.opt(key));
        }
        return data;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
