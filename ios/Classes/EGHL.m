#import "EGHL.h"
#import "EGHLPayViewController.h"
#import <objc/runtime.h>

@interface NSDictionary (BVJSONString)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end

@implementation NSDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];

    if (! jsonData) {
        NSLog(@"%s: error: %@", __func__, error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end

#pragma mark - eGHL secret debug fields...

@interface PaymentRequestPARAM ()
- (void)eghlDebugURL: (NSString *)urlString;
@end


#pragma mark - "Private" variables

@interface EGHL ()

@property Boolean processingInProgress;
@property UINavigationController *contentViewController;
@property FlutterResult flutterResult;
@property NSArray *eGHLStringParams;
@property NSArray *eGHLStringParams_mpeRequest;
@property UIViewController *viewController;

@end


#pragma mark - Implementation

@implementation EGHL

@synthesize processingInProgress;
@synthesize contentViewController;
@synthesize flutterResult;
@synthesize eGHLStringParams;
@synthesize eGHLStringParams_mpeRequest;
@synthesize viewController;


#pragma mark - Plugin API

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    return self;
}

- (void)pluginInitialize
{
    if(self.eGHLStringParams == nil) {
        self.eGHLStringParams = @[
            @"Amount",
            @"EPPMonth",
            @"PaymentID",
            @"OrderNumber",
            @"MerchantName",
            @"ServiceID",
            @"PymtMethod",
            @"MerchantReturnURL",
            @"CustEmail",
            @"Password",
            @"CustPhone",
            @"CurrencyCode",
            @"CustName",
            @"LanguageCode",
            @"PaymentDesc",
            @"PageTimeout",
            @"CustIP",
            @"MerchantApprovalURL",
            @"CustMAC",
            @"MerchantUnApprovalURL",
            @"CardHolder",
            @"CardNo",
            @"CardExp",
            @"CardCVV2",
            @"BillAddr",
            @"BillPostal",
            @"BillCity",
            @"BillRegion",
            @"BillCountry",
            @"eghlDebugURL",
            @"HashValue",
            @"PromoCode",
            @"ShipAddr",
            @"ShipPostal",
            @"ShipCity",
            @"ShipRegion",
            @"ShipCountry",
            @"TokenType",
            @"Token",
            @"TransactionType",
            @"SessionID",
            @"IssuingBank",
            @"MerchantCallBackURL",
            @"B4TaxAmt",
            @"TaxAmt",
            @"Param6",
            @"Param7",
            @"ReqToken",
            @"ReqVerifier",
            @"PairingToken",
            @"PairingVerifier",
            @"CheckoutResourceURL",
            @"CardId",
            @"PreCheckoutId",
            @"mpLightboxParameter",
        ];

        self.eGHLStringParams_mpeRequest = @[
            @"ServiceID",
            @"CurrencyCode",
            @"Amount",
            @"TokenType",
            @"Token",
            @"PaymentDesc",
        ];
    }
}

- (void)makePayment: (NSMutableDictionary*)args
        result: (FlutterResult)result
{
    if(self.processingInProgress) {
        result([FlutterError errorWithCode:@"REQUEST_IN_PROGRESS"
                             message:@"Another request is in progress. Please wait a few seconds."
                             details:nil]);
        return;
    }

    if(args == nil) {
        result([FlutterError errorWithCode:@"INVALID_PARAMETER"
                             message:@"Argument must be an object."
                             details:nil]);
        return;
    }

    self.processingInProgress = YES;
    self.flutterResult = result;

    PaymentRequestPARAM *payParams = [[PaymentRequestPARAM alloc] init];

    // Get Staging or production environment
    NSString *gatewayUrl = [args objectForKey:@"PaymentGateway"];
    if([gatewayUrl isEqualToString:@"https://test2pay.ghl.com/IPGSGOM/Payment.aspx"]) {
        // Special Masterpass development gateway... For TEMPORARY usage only!
        // TMP FIXME Remove when Masterpass is available in the normal
        // staging/production gateways.
        [payParams eghlDebugURL: @"https://test2pay.ghl.com/IPGSGOM/Payment.aspx?"];
    } else {
        payParams.realHost = [self isRealHost:gatewayUrl];
    }

    payParams.sdkTimeOut = [((NSNumber*) [args objectForKey:@"sdkTimeout"]) doubleValue];
    for(NSString *paramName in self.eGHLStringParams) {
        NSString *paramValue = [args objectForKey:paramName];
        if(paramValue != nil) {
            [payParams setValue:paramValue forKey:paramName];
        }
    }

    EGHLPayViewController *payViewController =
        [[EGHLPayViewController alloc] initWithEGHLPlugin:self
                                       andPayment:payParams
                                       andOtherParams:args];
    self.contentViewController = [[UINavigationController alloc] initWithRootViewController:payViewController];
    self.contentViewController.delegate = self;
    [self.viewController presentViewController:self.contentViewController
                         animated:YES
                         completion:^(void){}];
}

- (void)mpeRequest: (NSMutableDictionary*)args
        result: (FlutterResult)result
{
    if(self.processingInProgress) {
        result([FlutterError errorWithCode:@"REQUEST_IN_PROGRESS"
                             message:@"Another request is in progress. Please wait a few seconds."
                             details:nil]);
        return;
    }

    if(args == nil) {
        result([FlutterError errorWithCode:@"INVALID_PARAMETER"
                             message:@"Argument must be an object."
                             details:nil]);
        return;
    }

    self.processingInProgress = YES;
    self.flutterResult = result;

    PaymentRequestPARAM *params = [[PaymentRequestPARAM alloc] init];

    // Get Staging or production environment
    NSString *gatewayUrl = [args objectForKey:@"PaymentGateway"];
    if([gatewayUrl isEqualToString:@"https://test2pay.ghl.com/IPGSGOM/Payment.aspx"]) {
        // Special Masterpass development gateway... For TEMPORARY usage only!
        // TMP FIXME Remove when Masterpass is available in the normal
        // staging/production gateways.
        [params eghlDebugURL: @"https://test2pay.ghl.com/IPGSGOM/Payment.aspx?"];
    } else {
        params.realHost = [self isRealHost:gatewayUrl];
    }

    // Get other params from command arguments.
    params.sdkTimeOut = [((NSNumber*) [args objectForKey:@"sdkTimeout"]) doubleValue];
    for(NSString *paramName in self.eGHLStringParams_mpeRequest) {
        NSString *paramValue = [args objectForKey:paramName];
        if(paramValue != nil) {
            [params setValue:paramValue forKey:paramName];
        }
    }

    EGHLPayment *req = [[EGHLPayment alloc] init];
    [req eGHLMPERequest:params
         successBlock:^(PaymentRespPARAM *resp) {
             NSDictionary *dict = [self objectAsDictionary:resp];
             self.processingInProgress = NO;
             self.flutterResult([dict bv_jsonStringWithPrettyPrint:false]);
         }
         failedBlock:^(NSString *errorCode, NSString *errorData, NSError *error) {
             self.processingInProgress = NO;
             self.flutterResult([FlutterError errorWithCode:@"MPE_ERROR"
                                              message:@"Masterpass request error."
                                              details:nil]);
         }];
}


#pragma mark - Return to JS methods

- (void)endPaymentSuccessfullyWithResult: (PaymentRespPARAM*)result
{
    [self dismissContentView];
    self.processingInProgress = NO;

    // TODO send some fields e.g. TxnID, AuthCode, etc back to JS
    NSDictionary *dict = [self objectAsDictionary:result];
    self.flutterResult([dict bv_jsonStringWithPrettyPrint:false]);
}

- (void)endPaymentWithFailureMessage: (NSString*)message
{
    [self dismissContentView];
    self.processingInProgress = NO;
    self.flutterResult([FlutterError errorWithCode:@"PAYMENT_FAILED"
                                     message:@"Payment failed."
                                     details:nil]);
}

- (void)endPaymentWithCancellation
{
    [self dismissContentView];
    self.processingInProgress = NO;
    // TMP hard code -999 as cancel payment. (follow android SDK.)
    self.flutterResult([FlutterError errorWithCode:@"PAYMENT_CANCELLED"
                                     message:@"User cancelled payment."
                                     details:nil]);
}


#pragma mark - UINavigationControllerDelegate

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations: (UINavigationController*)navigationController;
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Internal helpers

- (void)dismissContentView
{
    [self.viewController dismissViewControllerAnimated:YES
                         completion:^(void){}];
}

- (Boolean)isRealHost: (NSString*)gateway
{
    return ![gateway isEqualToString:@"https://test2pay.ghl.com/IPGSG/Payment.aspx"];
}

// Get all non-nil fields in an NSObject and returns them in an NSDictionary.
// http://stackoverflow.com/a/31181746
- (NSDictionary*)objectAsDictionary: (NSObject*)object {
    // Get a list of all properties in the class.
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &count);

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    for(int i=0; i<count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [object valueForKey:key];

        // Only add to the NSDictionary if it's not nil.
        if (value) [dictionary setObject:value forKey:key];
    }

    free(properties);

    return dictionary;
}

@end
