//
//  ViewController.m
//  TapCardCheckoutExampleObjc
//
//  Created by Osama Rabie on 29/08/2022.
//

#import "ViewController.h"
@import TapCardCheckOutKit;
@import SharedDataModels_iOS;

@interface ViewController ()<TapCardViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *eventsTextView;
@property (weak, nonatomic) IBOutlet UIButton *tokenButton;
@property (weak, nonatomic) IBOutlet TapCardView *tapCardView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TapCardConfiguration* config = [[TapCardConfiguration alloc]initWithPublicKey:@"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7" scope:ScopeToken merchant:[[Merchant alloc]initWithId:@""] transaction:[[Transaction alloc]initWithAmount:1 currency:@"SAR"] authentication:[[Authentication alloc]initWithDescription:@"Authentication description" metadata:nil reference:[[Reference alloc]initWithTransaction:[self generateRandomTransactionId] order:[self generateRandomOrderId]] invoice:nil authentication:[[AuthenticationClass alloc]initWithChannel:@"PAYER_BROWSER" purpose:@"PAYMENT_TRANSACTION"] post:nil] customer:[[Customer alloc]initWithId:@"" name:@[[[Name alloc]initWithLang:@"en" first:@"Tap" last:@"Payments" middle:@""]] nameOnCard:@"TAP PAYMENTS" editable:YES contact:[[Contact alloc]initWithEmail:@"tap@tap.company" phone:[[Phone alloc]initWithCountryCode:@"965" number:@"88888888"]]] acceptance:[[Acceptance alloc]initWithSupportedBrands:@[@"MADA",@"MASTERCARD",@"MEEZA",@"VISA",@"OMANNET",@"AMERICAN_EXPRESS"] supportedCards:@[@"DEBIT",@"CREDIT"]] fields:[[Fields alloc]initWithCardHolder:YES] addons:[[Addons alloc]initWithDisplayPaymentBrands:YES loader:YES saveCard:NO] interface:[[Interface alloc]initWithLocale:@"en" theme:@"light" edges:@"curved" direction:@"ltr"]];
    
    
    [_tapCardView initTapCardSDKWithConfig:config delegate:self presentScannerIn:self];
    
    
}

-(NSString*)generateRandomTransactionId {
    int len = 23;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }

    return [NSString stringWithFormat:@"tck_LV%@",randomString];
}


-(NSString*)generateRandomOrderId {
    int len = 18;
    NSString *letters = @"0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return [NSString stringWithFormat:@"%@",randomString];
}

- (IBAction)generateToken:(id)sender {
    [_tapCardView generateTapToken];
}


- (void)onBinIdentificationWithData:(NSString *)data {
    [_eventsTextView setText: [NSString stringWithFormat: @"\n\n========\n\nonBinIdentificationWithData %@%@",data,_eventsTextView.text]];
}

- (void)onSuccessWithData:(NSString *)data {
    [_eventsTextView setText: [NSString stringWithFormat: @"\n\n========\n\nonSuccess %@%@",data,_eventsTextView.text]];
}

- (void)onReady {
    [_eventsTextView setText: [NSString stringWithFormat: @"\n\n========\n\nonReady"]];
}

- (void)onInvalidInputWithInvalid:(BOOL)invalid {
    [_eventsTextView setText: [NSString stringWithFormat: @"\n\n========\n\nonInvalidInputWithInvalid %i%@",invalid,_eventsTextView.text]];
}




@end
