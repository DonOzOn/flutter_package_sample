package com.example.miniapp_plugin;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.BatteryManager;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.app.AlertDialog;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** MiniappPlugin */
public class MiniappPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private FlutterPluginBinding flutterPluginBinding;
  private Context applicationContext;
  private android.app.Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
    this.applicationContext = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "miniapp_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    this.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    try {
      switch (call.method) {
        case "getPlatformVersion":
          result.success("Android " + Build.VERSION.RELEASE);
          break;
          
        case "getDeviceInfo":
          result.success(getDeviceInfo());
          break;
          
        case "isTablet":
          result.success(isTablet());
          break;
          
        case "getAppInfo":
          result.success(getAppInfo());
          break;
          
        case "openNativeView":
          String viewType = call.argument("viewType");
          Map<String, Object> params = call.argument("params");
          result.success(openNativeView(viewType, params));
          break;
          
        case "callNativeMethod":
          String method = call.argument("method");
          Map<String, Object> methodParams = call.argument("params");
          result.success(callNativeMethod(method, methodParams));
          break;
          
        case "hasPermission":
          String permission = call.argument("permission");
          result.success(hasPermission(permission));
          break;
          
        case "requestPermission":
          String permissionToRequest = call.argument("permission");
          result.success(requestPermission(permissionToRequest));
          break;
          
        case "getNetworkInfo":
          result.success(getNetworkInfo());
          break;
          
        case "showNativeDialog":
          String title = call.argument("title");
          String message = call.argument("message");
          List<String> buttons = call.argument("buttons");
          result.success(showNativeDialog(title, message, buttons));
          break;
          
        case "vibrate":
          Integer duration = call.argument("duration");
          result.success(vibrate(duration != null ? duration : 200));
          break;
          
        case "getBatteryInfo":
          result.success(getBatteryInfo());
          break;
          
        default:
          result.notImplemented();
          break;
      }
    } catch (Exception e) {
      result.error("NATIVE_ERROR", e.getMessage(), null);
    }
  }

  private Map<String, Object> getDeviceInfo() {
    Map<String, Object> deviceInfo = new HashMap<>();
    deviceInfo.put("platform", "Android");
    deviceInfo.put("version", Build.VERSION.RELEASE);
    deviceInfo.put("model", Build.MODEL);
    deviceInfo.put("manufacturer", Build.MANUFACTURER);
    deviceInfo.put("sdk_version", Build.VERSION.SDK_INT);
    deviceInfo.put("brand", Build.BRAND);
    deviceInfo.put("device", Build.DEVICE);
    deviceInfo.put("product", Build.PRODUCT);
    deviceInfo.put("hardware", Build.HARDWARE);
    return deviceInfo;
  }

  private boolean isTablet() {
    android.content.res.Configuration config = applicationContext.getResources().getConfiguration();
    return (config.screenLayout & android.content.res.Configuration.SCREENLAYOUT_SIZE_MASK) 
        >= android.content.res.Configuration.SCREENLAYOUT_SIZE_LARGE;
  }

  private Map<String, Object> getAppInfo() {
    Map<String, Object> appInfo = new HashMap<>();
    try {
      PackageManager packageManager = applicationContext.getPackageManager();
      PackageInfo packageInfo = packageManager.getPackageInfo(applicationContext.getPackageName(), 0);
      ApplicationInfo applicationInfo = packageManager.getApplicationInfo(applicationContext.getPackageName(), 0);
      
      appInfo.put("packageName", packageInfo.packageName);
      appInfo.put("versionName", packageInfo.versionName);
      appInfo.put("versionCode", packageInfo.versionCode);
      appInfo.put("appName", packageManager.getApplicationLabel(applicationInfo).toString());
      appInfo.put("targetSdkVersion", applicationInfo.targetSdkVersion);
      appInfo.put("minSdkVersion", applicationInfo.minSdkVersion);
      appInfo.put("installTime", packageInfo.firstInstallTime);
      appInfo.put("updateTime", packageInfo.lastUpdateTime);
    } catch (PackageManager.NameNotFoundException e) {
      appInfo.put("error", e.getMessage());
    }
    return appInfo;
  }

  private boolean openNativeView(String viewType, Map<String, Object> params) {
    if (activity == null) return false;
    
    try {
      // This is where you would open specific native views
      // For example, launching other activities or fragments
      switch (viewType) {
        case "settings":
          Intent settingsIntent = new Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
          settingsIntent.setData(android.net.Uri.parse("package:" + applicationContext.getPackageName()));
          activity.startActivity(settingsIntent);
          return true;
        case "gallery":
          Intent galleryIntent = new Intent(Intent.ACTION_VIEW);
          galleryIntent.setType("image/*");
          activity.startActivity(Intent.createChooser(galleryIntent, "Select Image"));
          return true;
        default:
          return false;
      }
    } catch (Exception e) {
      return false;
    }
  }

  private Object callNativeMethod(String method, Map<String, Object> params) {
    // Generic method for calling any native functionality
    switch (method) {
      case "getSystemProperty":
        String key = (String) params.get("key");
        return System.getProperty(key);
      case "getCurrentTime":
        return System.currentTimeMillis();
      case "getAvailableMemory":
        android.app.ActivityManager activityManager = (android.app.ActivityManager) 
            applicationContext.getSystemService(Context.ACTIVITY_SERVICE);
        android.app.ActivityManager.MemoryInfo memoryInfo = new android.app.ActivityManager.MemoryInfo();
        activityManager.getMemoryInfo(memoryInfo);
        Map<String, Object> memory = new HashMap<>();
        memory.put("availMem", memoryInfo.availMem);
        memory.put("totalMem", memoryInfo.totalMem);
        memory.put("lowMemory", memoryInfo.lowMemory);
        return memory;
      default:
        return null;
    }
  }

  private boolean hasPermission(String permission) {
    return ContextCompat.checkSelfPermission(applicationContext, permission) 
        == PackageManager.PERMISSION_GRANTED;
  }

  private boolean requestPermission(String permission) {
    if (activity == null) return false;
    
    if (!hasPermission(permission)) {
      ActivityCompat.requestPermissions(activity, new String[]{permission}, 1);
      return false; // Permission requested, actual result comes via callback
    }
    return true; // Already has permission
  }

  private String getNetworkInfo() {
    ConnectivityManager connectivityManager = 
        (ConnectivityManager) applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE);
    
    if (connectivityManager != null) {
      NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
      if (networkInfo != null && networkInfo.isConnected()) {
        return networkInfo.getTypeName() + " - " + networkInfo.getSubtypeName();
      }
    }
    return "Not Connected";
  }

  private boolean showNativeDialog(String title, String message, List<String> buttons) {
    if (activity == null) return false;
    
    activity.runOnUiThread(() -> {
      AlertDialog.Builder builder = new AlertDialog.Builder(activity);
      builder.setTitle(title);
      builder.setMessage(message);
      
      if (buttons != null && !buttons.isEmpty()) {
        for (int i = 0; i < buttons.size() && i < 3; i++) {
          final String buttonText = buttons.get(i);
          switch (i) {
            case 0:
              builder.setPositiveButton(buttonText, (dialog, which) -> dialog.dismiss());
              break;
            case 1:
              builder.setNegativeButton(buttonText, (dialog, which) -> dialog.dismiss());
              break;
            case 2:
              builder.setNeutralButton(buttonText, (dialog, which) -> dialog.dismiss());
              break;
          }
        }
      } else {
        builder.setPositiveButton("OK", (dialog, which) -> dialog.dismiss());
      }
      
      builder.show();
    });
    
    return true;
  }

  private boolean vibrate(int duration) {
    try {
      Vibrator vibrator = (Vibrator) applicationContext.getSystemService(Context.VIBRATOR_SERVICE);
      if (vibrator != null && vibrator.hasVibrator()) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          vibrator.vibrate(VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE));
        } else {
          vibrator.vibrate(duration);
        }
        return true;
      }
    } catch (Exception e) {
      return false;
    }
    return false;
  }

  private Map<String, Object> getBatteryInfo() {
    Map<String, Object> batteryInfo = new HashMap<>();
    
    try {
      IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
      Intent batteryStatus = applicationContext.registerReceiver(null, ifilter);
      
      if (batteryStatus != null) {
        int level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
        int scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        float batteryPct = level * 100 / (float) scale;
        
        int status = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
        boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                           status == BatteryManager.BATTERY_STATUS_FULL;
        
        int plugged = batteryStatus.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1);
        boolean usbCharge = plugged == BatteryManager.BATTERY_PLUGGED_USB;
        boolean acCharge = plugged == BatteryManager.BATTERY_PLUGGED_AC;
        
        batteryInfo.put("level", (int) batteryPct);
        batteryInfo.put("isCharging", isCharging);
        batteryInfo.put("usbCharge", usbCharge);
        batteryInfo.put("acCharge", acCharge);
        batteryInfo.put("status", status);
      }
    } catch (Exception e) {
      batteryInfo.put("error", e.getMessage());
    }
    
    return batteryInfo;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}