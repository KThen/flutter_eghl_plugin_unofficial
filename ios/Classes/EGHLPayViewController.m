/***

Initiates payment UI. Automatically re-queries eGHL for payment status if
necessary (at most one requery before giving up and failing).

***/

#import "EGHLPayViewController.h"

#pragma mark - Constants

#define CANCEL_PAYMENT_TAG 0xBEEF


#pragma mark - "Private" variables

@interface EGHLPayViewController ()

@property PaymentRequestPARAM *paymentParams;
@property EGHLPayment *eghlpay;
@property EGHL *cdvPlugin;
@property BOOL hasCancelled;

@end


#pragma mark - Implementation

@implementation EGHLPayViewController

@synthesize paymentParams;
@synthesize eghlpay;
@synthesize cdvPlugin;
@synthesize hasCancelled;


#pragma mark - Init

- (id)initWithEGHLPlugin: (EGHL*)cdvPlugin andPayment:(PaymentRequestPARAM*)payment andOtherParams:(NSDictionary*)otherParams;
{
    self = [super init];
    if(self) {
        self.cdvPlugin = cdvPlugin;
        self.paymentParams = payment;
        self.eghlpay = [[EGHLPayment alloc] init];
        self.eghlpay.delegate = self;
        self.hasCancelled = false;

        NSString *_finaliseMessage = [otherParams objectForKey:@"_finaliseMessage"];
        if(_finaliseMessage != nil) {
            self.eghlpay.finaliseMessage = _finaliseMessage;
        }
        NSString *_cancelMessage = [otherParams objectForKey:@"_cancelMessage"];
        if(_cancelMessage != nil) {
            self.eghlpay.cancelMessage = _cancelMessage;
        }
    }
    return self;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add cancel button
    UIBarButtonItem *cancelBtn =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                 target:self
                                 action:@selector(cancelPaymentPressed:)];
    [self.navigationItem setRightBarButtonItem:cancelBtn];

    // Add eGHL view
    [self.view addSubview:self.eghlpay];

    // Initiate payment process
    [self.eghlpay EGHLRequestSale:self.paymentParams
                  successBlock:^(NSString *successData) {}
                  failedBlock:^(NSString *errorCode, NSString *errorData, NSError *error) {
                      if(errorData) {
                          UIAlertController *alertView =
                              [UIAlertController alertControllerWithTitle:@"Error"
                                                 message:errorData
                                                 preferredStyle:UIAlertControllerStyleAlert];

                          UIAlertAction *actionOk =
                              [UIAlertAction actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 // Do nothing, just close this alert.
                                             }];

                          [alertView addAction:actionOk];

                          [self presentViewController:alertView
                                animated:YES
                                completion:^(void){}];
                      }
                  } ];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.eghlpay.frame = self.view.frame;
}


#pragma mark - Event Listeners

- (void)cancelPaymentPressed: (id)sender
{
    if(!self.hasCancelled) {
        UIAlertController *alertView =
            [UIAlertController alertControllerWithTitle:@"Are you sure?"
                               message:@"Pressing Abort will abandon the payment session."
                               preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *actionContinue =
            [UIAlertAction actionWithTitle:@"Continue with Payment"
                           style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * _Nonnull action) {
                               // Do nothing, just close this alert.
                           }];

        UIAlertAction *actionAbort =
            [UIAlertAction actionWithTitle:@"Abort"
                           style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * _Nonnull action) {
                              if(!self.hasCancelled) {
                                  self.hasCancelled = true;
                                  [self.eghlpay finalizeTransaction];
                              }
                           }];

        [alertView addAction:actionContinue];
        [alertView addAction:actionAbort];

        [self presentViewController:alertView
              animated:YES
              completion:^(void){}];
    }
}


#pragma mark - Helpers

- (void)processResults: (PaymentRespPARAM*)result withRequery: (BOOL)shouldRequery
{
    if(!result.TxnStatus) {
        // Unexpected nil fields.
        // TxnExists field will be null most of the time (when eGHL SDK is able
        // to grab payment response immediately) and may be non-null when eGHL
        // SDK had to perform a requery.
        [self.cdvPlugin endPaymentWithFailureMessage:result.TxnMessage];
    } else if(!result.TxnExists || [result.TxnExists isEqualToString:@"0"]) {
        // Transaction exists, or SDK returned immediate payment response - in
        // which case we assume transaction exists..
        if([result.TxnStatus isEqualToString:@"0"]) {
            // Transaction successful.
            [self.cdvPlugin endPaymentSuccessfullyWithResult:result];
        } else if([result.TxnStatus isEqualToString:@"1"]) {
            // Transaction failed or cancelled.
            // Check for "buyer cancelled" string in JS
            [self.cdvPlugin endPaymentWithFailureMessage:result.TxnMessage];
        } else if([result.TxnStatus isEqualToString:@"2"]) {
            if(shouldRequery) {
                // Transaction pending and should requery.
                [self performRequery];
            } else {
                // Transaction pending and should NOT requery. Assume user cancelled.
                [self.cdvPlugin endPaymentWithCancellation];
            }
        } else {
            // Unknown status.
            [self.cdvPlugin endPaymentWithFailureMessage:result.TxnMessage];
        }
    } else if(result.TxnExists) {
        if([result.TxnExists isEqualToString:@"1"]) {
            // Transaction not found in eGHL system. Assume user cancelled.
            [self.cdvPlugin endPaymentWithCancellation];
        } else if([result.TxnExists isEqualToString:@"2"]) {
            // Failed to query.
            if(shouldRequery) {
                [self performRequery];
            } else {
                [self.cdvPlugin endPaymentWithFailureMessage:result.TxnMessage];
            }
        }
    } else {
        // Unknown TxnExists value or nil.
        [self.cdvPlugin endPaymentWithFailureMessage:result.TxnMessage];
    }
}

- (void)performRequery
{
    EGHLPayment *queryEghlpay = [[EGHLPayment alloc] init];
    [queryEghlpay EGHLRequestQuery:self.paymentParams
                  successBlock:^(PaymentRespPARAM* result) {
                      [self processResults:result withRequery:NO];
                  }
                  failedBlock:^(NSString *errorCode, NSString *errorData, NSError *error) {
                      [self.cdvPlugin endPaymentWithCancellation];
                  }];
}


#pragma mark - eGHLDelegate

- (void)QueryResult: (PaymentRespPARAM*)result
{
    [self processResults:result withRequery:YES];
}

@end
