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
    } else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)fetchCacheABTest:(FlutterMethodCall*)call result:(FlutterResult)result{
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

-(void)asyncFetchABTest:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
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

-(void)fastFetchABTest:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    NSArray* arguments = (NSArray *)call.arguments;
    if (arguments.count < 3) {
        flutterResult(nil);
        return;
    }
    
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

- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData;
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

@end
