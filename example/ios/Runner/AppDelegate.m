#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#if __has_include(<SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#else
#import "SensorsAnalyticsSDK.h"
#endif

#import <SensorsABTest.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

//    [self startSensorsAnalyticsSDKWithOptions: launchOptions];
//    
//    [self startSensorsABTest];

//
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)startSensorsAnalyticsSDKWithOptions:(NSDictionary *)launchOptions {
    // 测试环境，数据接收地址
    NSString* kSABTestServerURL = @"http://10.130.6.4:8106/sa?project=default";
    
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:kSABTestServerURL launchOptions:launchOptions];
//    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppClick | SensorsAnalyticsEventTypeAppViewScreen;
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppClick | SensorsAnalyticsEventTypeAppViewScreen;
    //options.enableTrackAppCrash = YES;

    options.enableHeatMap = YES;
    options.enableVisualizedAutoTrack = YES;
    options.enableJavaScriptBridge = YES;
    options.enableLog = YES;
    options.flushNetworkPolicy = SensorsAnalyticsNetworkTypeALL;
    [SensorsAnalyticsSDK startWithConfigOptions:options];
    
    
    [SensorsAnalyticsSDK.sharedInstance track:@"test_track" withProperties:@{@"device_type": @"iPhone"}];
    

//    [[SensorsAnalyticsSDK sharedInstance] setFlushNetworkPolicy:SensorsAnalyticsNetworkTypeALL];
}

- (void)startSensorsABTest {
    // 测试环境，获取试验地址
    NSString* kSABResultsTestURL = @"http://abtesting.saas.debugbox.sensorsdata.cn/api/v2/abtest/online/results?project-key=438B9364C98D54371751BA82F6484A1A03A5155E";
    
    SensorsABTestConfigOptions *abtestConfigOptions = [[SensorsABTestConfigOptions alloc] initWithURL:kSABResultsTestURL];
    [SensorsABTest startWithConfigOptions:abtestConfigOptions];
    
}

@end
