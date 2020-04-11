#import "EghlpluginunofficialPlugin.h"
#import <objc/runtime.h>
#import <EGHL/EGHL.h>

@implementation EghlpluginunofficialPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"eghl_plugin_unofficial"
                                     binaryMessenger:[registrar messenger]];
    EghlpluginunofficialPlugin* instance = [[EghlpluginunofficialPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"makePayment" isEqualToString:call.method]) {
        PaymentRequestPARAM *params = [[PaymentRequestPARAM alloc]init];
        params.ServiceID = [call.arguments valueForKey:@"serviceId"];
        params.Amount = [self getKeyAsDecimalFormatted:call key:@"amount" format:@"%.02f"];
        params.MerchantName = [call.arguments valueForKey:@"merchantName"];
        params.PaymentID = [call.arguments valueForKey:@"paymentId"];
        params.OrderNumber = [call.arguments valueForKey:@"orderNumber"];
        params.CurrencyCode = [call.arguments valueForKey:@"currencyCode"];
        params.LanguageCode = [call.arguments valueForKey:@"languageCode"];
        params.PymtMethod = [call.arguments valueForKey:@"paymentMethod"];
        params.PageTimeout = [[call.arguments valueForKey:@"pageTimeoutSecs"] stringValue];
        params.TransactionType = [call.arguments valueForKey:@"transactionType"];
        params.MerchantReturnURL = [call.arguments valueForKey:@"merchantReturnUrl"];
        if ([self getKeyAsBoolean:call key:@"useDebugPaymentUrl"]) {
            params.settingDict = @{
                EGHL_DEBUG_PAYMENT_URL: @YES
            };
        } else {
            params.settingDict = @{
                EGHL_DEBUG_PAYMENT_URL: @NO
            };
        }
        params.sdkTimeOut = [[call.arguments valueForKey:@"pageTimeoutSecs"] doubleValue] + 60;
        
        NSString *paymentDescription = [call.arguments valueForKey:@"paymentDescription"];
        if (![paymentDescription isKindOfClass:[NSNull class]]) {
            params.PaymentDesc = paymentDescription;
        }
        
        NSString *customerIpAddress = [call.arguments valueForKey:@"customerIpAddress"];
        if (![customerIpAddress isKindOfClass:[NSNull class]]) {
            params.CustIP = customerIpAddress;
        }
        
        NSString *customerName = [call.arguments valueForKey:@"customerName"];
        if (![customerName isKindOfClass:[NSNull class]]) {
            params.CustName = customerName;
        }
        
        NSString *customerEmail = [call.arguments valueForKey:@"customerEmail"];
        if (![customerEmail isKindOfClass:[NSNull class]]) {
            params.CustEmail = customerEmail;
        }
        
        NSString *customerPhone = [call.arguments valueForKey:@"customerPhone"];
        if (![customerPhone isKindOfClass:[NSNull class]]) {
            params.CustPhone = customerPhone;
        }
        
        NSString *customerMacAddress = [call.arguments valueForKey:@"customerMacAddress"];
        if (![customerMacAddress isKindOfClass:[NSNull class]]) {
            params.CustMAC = customerMacAddress;
        }
        
        if ([self getKeyAsBoolean:call key:@"hadCustomerGaveConsent"]) {
            [params.settingDict setValue:@true forKey:EGHL_CARD_CUSTOMER_CONSENT];
        }
        
        NSString *promotionCode = [call.arguments valueForKey:@"promotionCode"];
        if (![promotionCode isKindOfClass:[NSNull class]]) {
            params.PromoCode = promotionCode;
        }
        
        NSString *beforeTaxAmount = [self getKeyAsDecimalFormatted:call key:@"beforeTaxAmount" format:@"%.02f"];
        if (![beforeTaxAmount isKindOfClass:[NSNull class]]) {
            params.B4TaxAmt = beforeTaxAmount;
        }
        
        NSString *taxAmount = [self getKeyAsDecimalFormatted:call key:@"taxAmount" format:@"%.02f"];
        if (![taxAmount isKindOfClass:[NSNull class]]) {
            params.TaxAmt = taxAmount;
        }
        
        NSString *eppMonth = [call.arguments valueForKey:@"eppMonth"];
        if (![eppMonth isKindOfClass:[NSNull class]]) {
            params.EPPMonth = eppMonth;
        }
        
        NSString *cardId = [call.arguments valueForKey:@"cardId"];
        if (![cardId isKindOfClass:[NSNull class]]) {
            params.CardId = cardId;
        }
        
        NSString *cardHolder = [call.arguments valueForKey:@"cardHolder"];
        if (![cardHolder isKindOfClass:[NSNull class]]) {
            params.CardHolder = cardHolder;
        }
        
        NSString *cardNumber = [call.arguments valueForKey:@"cardNumber"];
        if (![cardNumber isKindOfClass:[NSNull class]]) {
            params.CardNo = cardNumber;
        }
        
        NSString *cardExpiry = [call.arguments valueForKey:@"cardExpiry"];
        if (![cardExpiry isKindOfClass:[NSNull class]]) {
            params.CardExp = cardExpiry;
        }
        
        NSString *cardCvv2 = [call.arguments valueForKey:@"cardCvv2"];
        if (![cardCvv2 isKindOfClass:[NSNull class]]) {
            params.CardCVV2 = cardCvv2;
        }
        
        if ([self getKeyAsBoolean:call key:@"isCardPageEnabled"]) {
            [params.settingDict setValue:@true forKey:EGHL_ENABLED_CARD_PAGE];
        }
        
        if ([self getKeyAsBoolean:call key:@"isCvvOptional"]) {
            [params.settingDict setValue:@true forKey:EGHL_CVV_OPTIONAL];
        }
        
        NSString *issuingBank = [call.arguments valueForKey:@"issuingBank"];
        if (![issuingBank isKindOfClass:[NSNull class]]) {
            params.IssuingBank = issuingBank;
        }
        
        NSString *tokenType = [call.arguments valueForKey:@"tokenType"];
        if (![tokenType isKindOfClass:[NSNull class]]) {
            params.TokenType = tokenType;
        }
        
        NSString *token = [call.arguments valueForKey:@"token"];
        if (![token isKindOfClass:[NSNull class]]) {
            params.Token = token;
        }
        
        NSString *pairingToken = [call.arguments valueForKey:@"pairingToken"];
        if (![pairingToken isKindOfClass:[NSNull class]]) {
            params.PairingToken = pairingToken;
        }
        
        NSString *requestToken = [call.arguments valueForKey:@"requestToken"];
        if (![requestToken isKindOfClass:[NSNull class]]) {
            params.ReqToken = requestToken;
        }
        
        NSString *requestVerifier = [call.arguments valueForKey:@"requestVerifier"];
        if (![requestVerifier isKindOfClass:[NSNull class]]) {
            params.ReqVerifier = requestVerifier;
        }
        
        NSString *pairingVerifier = [call.arguments valueForKey:@"pairingVerifier"];
        if (![pairingVerifier isKindOfClass:[NSNull class]]) {
            params.PairingVerifier = pairingVerifier;
        }
        
        if ([self getKeyAsBoolean:call key:@"isTokenizeRequired"]) {
            [params.settingDict setValue:@true forKey:EGHL_TOKENIZE_REQUIRED];
        }
        
        NSString *merchantCallbackUrl = [call.arguments valueForKey:@"merchantCallbackUrl"];
        if (![merchantCallbackUrl isKindOfClass:[NSNull class]]) {
            params.MerchantCallBackURL = merchantCallbackUrl;
        }
        
        NSString *merchantApprovalUrl = [call.arguments valueForKey:@"merchantApprovalUrl"];
        if (![merchantApprovalUrl isKindOfClass:[NSNull class]]) {
            params.MerchantApprovalURL = merchantApprovalUrl;
        }
        
        NSString *merchantDisapprovalUrl = [call.arguments valueForKey:@"merchantDisapprovalUrl"];
        if (![merchantDisapprovalUrl isKindOfClass:[NSNull class]]) {
            params.MerchantUnApprovalURL = merchantDisapprovalUrl;
        }
        
        NSString *checkoutResourceUrl = [call.arguments valueForKey:@"checkoutResourceUrl"];
        if (![checkoutResourceUrl isKindOfClass:[NSNull class]]) {
            params.CheckoutResourceURL = checkoutResourceUrl;
        }
        
        if ([self getKeyAsBoolean:call key:@"shouldTriggerReturnUrl"]) {
            [params.settingDict setValue:@true forKey:EGHL_SHOULD_TRIGGER_RETURN_URL];
        }
        
        NSString *param6 = [call.arguments valueForKey:@"param6"];
        if (![param6 isKindOfClass:[NSNull class]]) {
            params.Param6 = param6;
        }
        
        NSString *param7 = [call.arguments valueForKey:@"param7"];
        if (![param7 isKindOfClass:[NSNull class]]) {
            params.Param7 = param7;
        }
        
        NSString *billingAddress = [call.arguments valueForKey:@"billingAddress"];
        if (![billingAddress isKindOfClass:[NSNull class]]) {
            params.BillAddr = billingAddress;
        }
        
        NSString *billingPostalCode = [call.arguments valueForKey:@"billingPostalCode"];
        if (![billingPostalCode isKindOfClass:[NSNull class]]) {
            params.BillPostal = billingPostalCode;
        }
        
        NSString *billingCity = [call.arguments valueForKey:@"billingCity"];
        if (![billingCity isKindOfClass:[NSNull class]]) {
            params.BillCity = billingCity;
        }
        
        NSString *billingRegion = [call.arguments valueForKey:@"billingRegion"];
        if (![billingRegion isKindOfClass:[NSNull class]]) {
            params.BillRegion = billingRegion;
        }
        
        NSString *billingCountry = [call.arguments valueForKey:@"billingCountry"];
        if (![billingCountry isKindOfClass:[NSNull class]]) {
            params.BillCountry = billingCountry;
        }
        
        NSString *shippingAddress = [call.arguments valueForKey:@"shippingAddress"];
        if (![shippingAddress isKindOfClass:[NSNull class]]) {
            params.ShipAddr = shippingAddress;
        }
        
        NSString *shippingPostalCode = [call.arguments valueForKey:@"shippingPostalCode"];
        if (![shippingPostalCode isKindOfClass:[NSNull class]]) {
            params.ShipPostal = shippingPostalCode;
        }
        
        NSString *shippingCity = [call.arguments valueForKey:@"shippingCity"];
        if (![shippingCity isKindOfClass:[NSNull class]]) {
            params.ShipCity = shippingCity;
        }
        
        NSString *shippingRegion = [call.arguments valueForKey:@"shippingRegion"];
        if (![shippingRegion isKindOfClass:[NSNull class]]) {
            params.ShipRegion = shippingRegion;
        }
        
        NSString *shippingCountry = [call.arguments valueForKey:@"shippingCountry"];
        if (![shippingCountry isKindOfClass:[NSNull class]]) {
            params.ShipCountry = shippingCountry;
        }
        
        NSString *sessionId = [call.arguments valueForKey:@"sessionId"];
        if (![sessionId isKindOfClass:[NSNull class]]) {
            params.SessionID = sessionId;
        }
        
        NSString *password = [call.arguments valueForKey:@"password"];
        if (![password isKindOfClass:[NSNull class]]) {
            params.Password = password;
        }
        
        NSString *preCheckoutId = [call.arguments valueForKey:@"preCheckoutId"];
        if (![preCheckoutId isKindOfClass:[NSNull class]]) {
            params.PreCheckoutId = preCheckoutId;
        }
        
        EGHLPayment *eghl = [[EGHLPayment alloc]init];
        
        [eghl execute:params fromViewController:[UIApplication sharedApplication].delegate.window.rootViewController successBlock:^(PaymentRespPARAM *responseData) {
            
            [[UIApplication sharedApplication].delegate.window.rootViewController dismissViewControllerAnimated:YES completion:^(void){}];
            
            NSDictionary *dict = [self objectAsDictionary:responseData];
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
            
            result([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        } failedBlock:^(NSString *errorCode, NSString *errorData, NSError *error) {
            [[UIApplication sharedApplication].delegate.window.rootViewController dismissViewControllerAnimated:YES completion:^(void){}];
            
            result([FlutterError errorWithCode:errorCode message:errorData details:nil]);
        }];
    } else if ([@"generateId" isEqualToString:call.method]) {
        NSString *prefix = call.arguments;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMddHHmm"];
        
        NSString * dateString = [df stringFromDate:[NSDate date]];
        
        int value = arc4random_uniform(9999 + 1);
        
        result([NSString stringWithFormat:@"%@%@%d", prefix, dateString, value]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (bool)keyExists:(FlutterMethodCall*)call key:(NSString*)key {
    if ([[call.arguments valueForKey:key] isKindOfClass:[NSNull class]]) {
        return false;
    }
    return true;
}

- (BOOL)getKeyAsBoolean:(FlutterMethodCall*)call key:(NSString*)key {
    if (![self keyExists:call key:key]) {
        return nil;
    }
    return [[call.arguments valueForKey:key] boolValue];
}

- (NSString*)getKeyAsDecimalFormatted:(FlutterMethodCall*)call key:(NSString*)key format:(NSString*)format {
    if (![self keyExists:call key:key]) {
        return nil;
    }
    return [NSString stringWithFormat:format, [[call.arguments valueForKey:key] floatValue]];
}

- (NSDictionary*)objectAsDictionary: (NSObject*)object {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    for(int i=0; i<count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [object valueForKey:key];
        
        if (value) [dictionary setObject:value forKey:key];
    }
    
    free(properties);
    
    return dictionary;
}

@end
