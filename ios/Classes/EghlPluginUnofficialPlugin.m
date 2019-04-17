#import "EghlPluginUnofficialPlugin.h"
#import "EGHL.h"

@implementation EghlPluginUnofficialPlugin

- (instancetype)initWithEghl:(EGHL *)eghl {
    self.eghl = eghl;
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"eghl_plugin_unofficial"
            binaryMessenger:[registrar messenger]];

  UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  EGHL *eghl = [[EGHL alloc]initWithViewController: viewController];
  [eghl pluginInitialize];

  EghlPluginUnofficialPlugin* instance = [[EghlPluginUnofficialPlugin alloc] initWithEghl:eghl];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"makePayment" isEqualToString:call.method]) {
    [self.eghl makePayment:call.arguments result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
