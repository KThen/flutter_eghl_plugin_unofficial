#import <Flutter/Flutter.h>
#import "EGHL.h"

@interface EghlPluginUnofficialPlugin : NSObject<FlutterPlugin>

@property EGHL *eghl;

- (instancetype)initWithEghl: (EGHL *)eghl;

@end
