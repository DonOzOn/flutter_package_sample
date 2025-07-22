#import "MiniappPlugin.h"
#import <UIKit/UIKit.h>

@implementation MiniappPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"miniapp_plugin"
            binaryMessenger:[registrar messenger]];
  MiniappPlugin* instance = [[MiniappPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  @try {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
      
    } else if ([@"getDeviceInfo" isEqualToString:call.method]) {
      result([self getDeviceInfo]);
      
    } else if ([@"isTablet" isEqualToString:call.method]) {
      BOOL isTablet = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
      result(@(isTablet));
      
    } else if ([@"getAppInfo" isEqualToString:call.method]) {
      result([self getAppInfo]);
      
    } else if ([@"openNativeView" isEqualToString:call.method]) {
      NSString* viewType = call.arguments[@"viewType"];
      NSDictionary* params = call.arguments[@"params"];
      result(@([self openNativeView:viewType withParams:params]));
      
    } else if ([@"callNativeMethod" isEqualToString:call.method]) {
      NSString* method = call.arguments[@"method"];
      NSDictionary* params = call.arguments[@"params"];
      result([self callNativeMethod:method withParams:params]);
      
    } else if ([@"hasPermission" isEqualToString:call.method]) {
      NSString* permission = call.arguments[@"permission"];
      result(@([self hasPermission:permission]));
      
    } else if ([@"requestPermission" isEqualToString:call.method]) {
      NSString* permission = call.arguments[@"permission"];
      result(@([self requestPermission:permission]));
      
    } else if ([@"getNetworkInfo" isEqualToString:call.method]) {
      result([self getNetworkInfo]);
      
    } else if ([@"showNativeDialog" isEqualToString:call.method]) {
      NSString* title = call.arguments[@"title"];
      NSString* message = call.arguments[@"message"];
      NSArray* buttons = call.arguments[@"buttons"];
      result(@([self showNativeDialog:title message:message buttons:buttons]));
      
    } else if ([@"vibrate" isEqualToString:call.method]) {
      NSNumber* duration = call.arguments[@"duration"];
      result(@([self vibrate:[duration intValue]]));
      
    } else if ([@"getBatteryInfo" isEqualToString:call.method]) {
      result([self getBatteryInfo]);
      
    } else {
      result(FlutterMethodNotImplemented);
    }
  } @catch (NSException *exception) {
    result([FlutterError errorWithCode:@"NATIVE_ERROR"
                               message:exception.reason
                               details:nil]);
  }
}

- (NSDictionary*)getDeviceInfo {
  UIDevice* device = [UIDevice currentDevice];
  return @{
    @"platform": @"iOS",
    @"version": device.systemVersion,
    @"model": device.model,
    @"name": device.name,
    @"system_name": device.systemName,
    @"identifier_for_vendor": device.identifierForVendor.UUIDString ?: @"",
    @"user_interface_idiom": @(device.userInterfaceIdiom),
    @"battery_monitoring_enabled": @(device.batteryMonitoringEnabled),
    @"multitasking_supported": @(device.multitaskingSupported)
  };
}

- (NSDictionary*)getAppInfo {
  NSBundle* bundle = [NSBundle mainBundle];
  NSDictionary* infoDictionary = bundle.infoDictionary;
  
  return @{
    @"bundle_identifier": bundle.bundleIdentifier ?: @"",
    @"version": infoDictionary[@"CFBundleShortVersionString"] ?: @"",
    @"build_number": infoDictionary[@"CFBundleVersion"] ?: @"",
    @"app_name": infoDictionary[@"CFBundleDisplayName"] ?: infoDictionary[@"CFBundleName"] ?: @"",
    @"bundle_path": bundle.bundlePath,
    @"executable_path": bundle.executablePath ?: @"",
    @"minimum_os_version": infoDictionary[@"MinimumOSVersion"] ?: @""
  };
}

- (BOOL)openNativeView:(NSString*)viewType withParams:(NSDictionary*)params {
  UIApplication* app = [UIApplication sharedApplication];
  
  if ([@"settings" isEqualToString:viewType]) {
    NSURL* settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:settingsURL]) {
      if (@available(iOS 10.0, *)) {
        [app openURL:settingsURL options:@{} completionHandler:nil];
      } else {
        [app openURL:settingsURL];
      }
      return YES;
    }
  } else if ([@"photos" isEqualToString:viewType]) {
    NSURL* photosURL = [NSURL URLWithString:@"photos-redirect://"];
    if ([app canOpenURL:photosURL]) {
      if (@available(iOS 10.0, *)) {
        [app openURL:photosURL options:@{} completionHandler:nil];
      } else {
        [app openURL:photosURL];
      }
      return YES;
    }
  }
  
  return NO;
}

- (id)callNativeMethod:(NSString*)method withParams:(NSDictionary*)params {
  if ([@"getCurrentTime" isEqualToString:method]) {
    return @([[NSDate date] timeIntervalSince1970] * 1000);
    
  } else if ([@"getSystemInfo" isEqualToString:method]) {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return @{
      @"sysname": @(systemInfo.sysname),
      @"nodename": @(systemInfo.nodename),
      @"release": @(systemInfo.release),
      @"version": @(systemInfo.version),
      @"machine": @(systemInfo.machine)
    };
    
  } else if ([@"getMemoryInfo" isEqualToString:method]) {
    vm_size_t page_size;
    mach_port_t mach_port = mach_host_self();
    vm_statistics64_data_t vm_stat;
    mach_msg_type_number_t host_size = sizeof(vm_statistics64_data_t) / sizeof(natural_t);
    
    host_page_size(mach_port, &page_size);
    host_statistics64(mach_port, HOST_VM_INFO, (host_info64_t)&vm_stat, &host_size);
    
    return @{
      @"free_memory": @(vm_stat.free_count * page_size),
      @"inactive_memory": @(vm_stat.inactive_count * page_size),
      @"active_memory": @(vm_stat.active_count * page_size),
      @"wired_memory": @(vm_stat.wire_count * page_size)
    };
  }
  
  return nil;
}

- (BOOL)hasPermission:(NSString*)permission {
  // iOS permission checking examples
  if ([@"camera" isEqualToString:permission]) {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return status == AVAuthorizationStatusAuthorized;
    
  } else if ([@"photos" isEqualToString:permission]) {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return status == PHAuthorizationStatusAuthorized;
    
  } else if ([@"location" isEqualToString:permission]) {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return status == kCLAuthorizationStatusAuthorizedWhenInUse || 
           status == kCLAuthorizationStatusAuthorizedAlways;
  }
  
  return NO;
}

- (BOOL)requestPermission:(NSString*)permission {
  // Permission requesting would typically involve delegate callbacks
  // This is a simplified implementation
  return [self hasPermission:permission];
}

- (NSString*)getNetworkInfo {
  // Basic reachability check
  struct sockaddr_in zeroAddress;
  bzero(&zeroAddress, sizeof(zeroAddress));
  zeroAddress.sin_len = sizeof(zeroAddress);
  zeroAddress.sin_family = AF_INET;
  
  SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
  
  if (reachabilityRef) {
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
      CFRelease(reachabilityRef);
      
      if ((flags & kSCNetworkReachabilityFlagsReachable) && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)) {
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
          return @"Cellular";
        } else {
          return @"WiFi";
        }
      }
    }
    CFRelease(reachabilityRef);
  }
  
  return @"Not Connected";
}

- (BOOL)showNativeDialog:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleAlert];
  
  if (buttons && buttons.count > 0) {
    for (NSString* buttonTitle in buttons) {
      UIAlertAction* action = [UIAlertAction actionWithTitle:buttonTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
      [alert addAction:action];
    }
  } else {
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
    [alert addAction:okAction];
  }
  
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController* rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (rootViewController) {
      [rootViewController presentViewController:alert animated:YES completion:nil];
    }
  });
  
  return YES;
}

- (BOOL)vibrate:(int)duration {
  // iOS has limited vibration control
  // For basic vibration, use AudioServicesPlaySystemSound
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  return YES;
}

- (NSDictionary*)getBatteryInfo {
  UIDevice* device = [UIDevice currentDevice];
  device.batteryMonitoringEnabled = YES;
  
  return @{
    @"level": @((int)(device.batteryLevel * 100)),
    @"state": @(device.batteryState),
    @"monitoring_enabled": @(device.batteryMonitoringEnabled),
    @"is_charging": @(device.batteryState == UIDeviceBatteryStateCharging || 
                     device.batteryState == UIDeviceBatteryStateFull)
  };
}

@end