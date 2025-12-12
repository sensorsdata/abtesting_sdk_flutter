package com.sensorsdata.analytics.abtesting.abtesting_sdk_flutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.sensorsdata.abtest.OnABTestReceivedData;
import com.sensorsdata.abtest.SensorsABTest;
import com.sensorsdata.abtest.SensorsABTestConfigOptions;
import com.sensorsdata.abtest.SensorsABTestExperiment;

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
    /// The MethodChannel that will the communication between Flutter and native
    /// Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine
    /// and unregister it
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
            case "setCustomIDs":
                setCustomIDs(call, result);
                break;
            case "setCustomProperties":
                setCustomProperties(call, result);
                break;
            case "fastFetchABTestWithExperiment":
                fastFetchABTestWithExperiment(call, result);
                break;
            case "asyncFetchABTestWithExperiment":
                asyncFetchABTestWithExperiment(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void startWithConfigOptions(MethodCall call, Result result) {
        Map<String, Object> args = call.arguments();

        String urlString = (String) args.get("urlString");
        Object customObj = args.get("customProperties");
        Map<String, Object> customProperties = null;
        if (customObj instanceof Map) {
            customProperties = (Map<String, Object>) customObj;
        }

        SensorsABTestConfigOptions abTestConfigOptions = new SensorsABTestConfigOptions(urlString);
        if (customProperties != null) {
            abTestConfigOptions.setCustomProperties(assertMapToJSON(customProperties));
        }
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

    private void fastFetchABTestWithExperiment(MethodCall call, final Result result) {
        List list = (List) call.arguments;
        if (list == null || list.size() == 0) {
            result.success(null);
            return;
        }

        Map<String, Object> experimenMap = (Map<String, Object>) list.get(0);
        // 构建最终的 Experiment
        SensorsABTestExperiment<Object> experiment = buildExperimentFromMap(experimenMap);

        SensorsABTest.shareInstance().fastFetchABTest(experiment, new OnABTestReceivedData() {
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

    private void asyncFetchABTestWithExperiment(MethodCall call, final Result result) {
        List list = (List) call.arguments;
        if (list == null || list.size() == 0) {
            result.success(null);
            return;
        }

        Map<String, Object> experimenMap = (Map<String, Object>) list.get(0);

        // 构建最终的 Experiment
        SensorsABTestExperiment<Object> experiment = buildExperimentFromMap(experimenMap);

        SensorsABTest.shareInstance().asyncFetchABTest(experiment, new OnABTestReceivedData() {
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

    private void setCustomIDs(MethodCall call, Result result) {
        Map<String, String> customIDs = call.arguments();
        SensorsABTest.shareInstance().setCustomIDs(customIDs);
        result.success(null);
    }

    private void setCustomProperties(MethodCall call, Result result) {
        Map<String, Object> customProperties = call.arguments();
        SensorsABTest.shareInstance().setCustomProperties(assertMapToJSON(customProperties));
        result.success(null);
    }

    // 从 Map 构建 Experiment 对象
    private SensorsABTestExperiment<Object> buildExperimentFromMap(Map<String, Object> experimentDic) {
        String paramName = (String) experimentDic.get("paramName");
        Object defaultValue = experimentDic.get("defaultValue");
        if (defaultValue instanceof Map) {
            defaultValue = new JSONObject((Map) defaultValue);
        }

        SensorsABTestExperiment.ExperimentBuilder<Object> builder = SensorsABTestExperiment.newBuilder(paramName,
                defaultValue);
        Object timeoutObj = experimentDic.get("timeoutInterval");
        if (timeoutObj instanceof Number) {
            int timeout = ((Number) timeoutObj).intValue(); // 毫秒
            builder.setTimeoutMillSeconds(timeout);
        }

        Map<String, Object> properties = (Map<String, Object>) experimentDic.get("properties");
        if (properties != null) {
            for (String key : properties.keySet()) {
                Object value = properties.get(key);

                if (value == null) {
                    builder.addProperty(key, (String) null);
                } else if (value instanceof String) {
                    builder.addProperty(key, (String) value);
                } else if (value instanceof Boolean) {
                    builder.addProperty(key, (Boolean) value);
                } else if (value instanceof Integer) {
                    builder.addProperty(key, (Integer) value);
                } else if (value instanceof Long) {
                    builder.addProperty(key, (Long) value);
                } else if (value instanceof Double) {
                    builder.addProperty(key, (Double) value);
                } else if (value instanceof Float) {
                    builder.addProperty(key, ((Float) value).doubleValue());
                } else if (value instanceof List) {
                    try {
                        builder.addProperty(key, (List<String>) value);
                    } catch (Exception e) {
                    }
                } else {
                    // 兜底处理，直接转字符串
                    builder.addProperty(key, String.valueOf(value));
                }
            }
        }

        // 构建最终的 Experiment
        SensorsABTestExperiment<Object> experiment = builder.create();
        return experiment;
    }

    private void checkResult(Object abResult, Result result) {
        try {
            if (abResult instanceof JSONObject) {
                JSONObject jsonObject = (JSONObject) abResult;
                result.success(jsonObject.toString());
                return;
            }
            result.success(abResult);
        } catch (java.lang.Exception e) {
            // ignored
        }
    }

    private static JSONObject assertMapToJSON(Map<String, Object> map) {
        if (map != null) {
            return new JSONObject(map);
        } else {
            // SALog.d(TAG, "传入的属性为空");
            return null;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
