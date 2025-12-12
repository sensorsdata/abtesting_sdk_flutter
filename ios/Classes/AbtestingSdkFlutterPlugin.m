#import "AbtestingSdkFlutterPlugin.h"
#import "SensorsABTest.h"

@implementation AbtestingSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"sa_abtesting_sdk"
                                     binaryMessenger:[registrar messenger]];
    AbtestingSdkFlutterPlugin* instance = [[AbtestingSdkFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"fetchCacheABTest" isEqualToString:call.method]) {
        [self fetchCacheABTest:call result:result];
    } else if ([@"asyncFetchABTest" isEqualToString:call.method]) {
        [self asyncFetchABTest:call result:result];
    } else if ([@"fastFetchABTest" isEqualToString:call.method]) {
        [self fastFetchABTest:call result:result];
    } else if ([@"startWithConfigOptions" isEqualToString:call.method]) {
        [self startWithConfigOptions:call result:result];
    } else if ([@"setCustomIDs" isEqualToString:call.method]) {
        [self setCustomIDs:call result:result];
    } else if ([@"setCustomProperties" isEqualToString:call.method]) {
        [self setCustomProperties:call result:result];
    } else if ([@"fastFetchABTestWithExperiment" isEqualToString:call.method]) {
        [self fastFetchABTestWithExperiment:call result:result];
    } else if ([@"asyncFetchABTestWithExperiment" isEqualToString:call.method]) {
        [self asyncFetchABTestWithExperiment:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
 
- (void)startWithConfigOptions:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSDictionary *args = call.arguments;
    NSString *urlString = args[@"urlString"];
    NSDictionary *customProperties = args[@"customProperties"];

    SensorsABTestConfigOptions *abtestConfigOptions = [[SensorsABTestConfigOptions alloc] initWithURL:urlString];
    if (customProperties != nil && [customProperties isKindOfClass:[NSDictionary class]]) {
        abtestConfigOptions.customProperties = customProperties;
    }
    [SensorsABTest startWithConfigOptions:abtestConfigOptions];
    result(nil);
}

- (void)fetchCacheABTest:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSArray* arguments = (NSArray *)call.arguments;
    if (arguments.count < 2) {
        result(nil);
        return;
    }
    id finalresult =  [[SensorsABTest sharedInstance] fetchCacheABTestWithParamName:arguments[0] defaultValue:arguments[1]];

    if([finalresult isKindOfClass:[NSDictionary class]]){
        NSDictionary* dic = finalresult;
        finalresult = [self convertToJsonData:dic];
    }
    result(finalresult);
}

- (void)asyncFetchABTest:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    NSArray* arguments = (NSArray *)call.arguments;
    if (arguments.count < 3) {
        flutterResult(nil);
        return;
    }
    NSString* paramName = arguments[0];
    double second = [arguments[2] doubleValue] / 1000;
    
    [[SensorsABTest sharedInstance] asyncFetchABTestWithParamName:paramName defaultValue:arguments[1] timeoutInterval:second  completionHandler:^(id  _Nullable finalresult) {
        if([finalresult isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = finalresult;
            finalresult = [self convertToJsonData:dic];
        }
        flutterResult(finalresult);
    }];
}

- (void)fastFetchABTest:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    NSArray* arguments = (NSArray *)call.arguments;
    NSString* paramName = arguments[0];
    double second = [arguments[2] doubleValue] / 1000;

    [[SensorsABTest sharedInstance] fastFetchABTestWithParamName:paramName defaultValue:arguments[1] timeoutInterval:second  completionHandler:^(id  _Nullable finalresult) {
        if([finalresult isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = finalresult;
            finalresult = [self convertToJsonData:dic];
        }
        flutterResult(finalresult);
    }];
}

- (void)fastFetchABTestWithExperiment:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    NSArray* arguments = (NSArray *)call.arguments;
    if (arguments.count == 0) {
        flutterResult(nil);
        return;
    }
    
    NSDictionary *experimentDic = arguments[0];
    SensorsABTestExperiment *experiment = [SensorsABTestExperiment experimentWithParamName:experimentDic[@"paramName"] defaultValue:experimentDic[@"defaultValue"]];
    if (experimentDic[@"timeoutInterval"]) {
        experiment.timeoutInterval = [experimentDic[@"timeoutInterval"] doubleValue] / 1000;
    }
    experiment.properties = experimentDic[@"properties"];

    [[SensorsABTest sharedInstance] fastFetchABTestWithExperiment:experiment completionHandler:^(id  _Nullable finalresult) {
        if([finalresult isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = finalresult;
            finalresult = [self convertToJsonData:dic];
        }
        flutterResult(finalresult);
    }];
}

- (void)asyncFetchABTestWithExperiment:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    NSArray* arguments = (NSArray *)call.arguments;
    if (arguments.count == 0) {
        flutterResult(nil);
        return;
    }
    
    NSDictionary *experimentDic = arguments[0];
    SensorsABTestExperiment *experiment = [SensorsABTestExperiment experimentWithParamName:experimentDic[@"paramName"] defaultValue:experimentDic[@"defaultValue"]];
    if (experimentDic[@"timeoutInterval"]) {
        experiment.timeoutInterval = [experimentDic[@"timeoutInterval"] doubleValue] / 1000;
    }
    experiment.properties = experimentDic[@"properties"];

    [[SensorsABTest sharedInstance] asyncFetchABTestWithExperiment:experiment completionHandler:^(id  _Nullable finalresult) {
        if([finalresult isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = finalresult;
            finalresult = [self convertToJsonData:dic];
        }
        flutterResult(finalresult);
    }];
}


- (void)setCustomIDs:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *customIDs = call.arguments;
    [[SensorsABTest sharedInstance] setCustomIDs:customIDs];
    result(nil);
}

- (void)setCustomProperties:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *customProperties = call.arguments;
    [[SensorsABTest sharedInstance] setCustomProperties:customProperties];
    result(nil);
}

/// NSDictionary 转 JSON 字符串
- (NSString *)convertToJsonData:(NSDictionary *)dict {
    if (![NSJSONSerialization isValidJSONObject:dict]) {
        NSLog(@"obj is not valid JSON: %@",dict);
        return nil;
    }

    NSError *error = nil;
    NSData *jsonData = nil;
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }

    if (!jsonData) {
        NSLog(@"error: %@",error);
        return nil;
    }
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
