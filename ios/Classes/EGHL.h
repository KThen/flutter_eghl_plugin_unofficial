#import <eghl_plugin_unofficial/EGHLPayment.h>
#import <Flutter/Flutter.h>

@interface EGHL : UINavigationController <UINavigationControllerDelegate>

- (instancetype)initWithViewController: (UIViewController *)viewController;
- (void)pluginInitialize;

- (void)makePayment: (NSMutableDictionary*)args
        result: (FlutterResult)result;
- (void)mpeRequest: (NSMutableDictionary*)args
        result: (FlutterResult)result;

- (void)endPaymentSuccessfullyWithResult: (PaymentRespPARAM*)result;
- (void)endPaymentWithFailureMessage: (NSString*)message;
- (void)endPaymentWithCancellation;

@end
