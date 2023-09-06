//
//  ViewController.m
//  TapCardCheckoutExampleObjc
//
//  Created by Osama Rabie on 29/08/2022.
//

#import "ViewController.h"
@import TapCardCheckOutKit;
@import CommonDataModelsKit_iOS;
@import TapCardVlidatorKit_iOS;
@import TapCardScanner_iOS;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_startButton setEnabled:NO];
    CheckoutSecretKey* publicKey = [[CheckoutSecretKey alloc]initWithSandbox:@"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7" production:@"sk_live_V4UDhitI0r7sFwHCfNB6xMKp"];
    Scope scope = ScopeTapToken;
    CheckoutOrder* order = [[CheckoutOrder alloc]initWithIdentifier:@""];
    Features* features = [[Features alloc]initWithAcceptanceBadge:YES];
    
    Transaction* transaction = [[Transaction alloc]initWithAmount:1 currency:TapCurrencyCodeKWD];
    Merchant* merchant = [[Merchant alloc]initWithId:@"ID"];
    TapCustomer* customer = [[TapCustomer alloc]initWithEmailAddress:[[TapEmailAddress alloc] initWithEmailAddressString:@"tap@company.com"]
                                                         phoneNumber:[[TapPhone alloc]initWithIsdNumber:@"" phoneNumber:@"" error:nil]
                                                           firstName:@"First Name"
                                                          middleName:@"Not Needed"
                                                            lastName:@"Last Name"
                                                             address:nil
                                                          nameOnCard:@"Customer's card holder name"
                                                            editable:YES];
    CardBrand brand = CardBrandMada;
    
    Acceptance* acceptance = [[Acceptance alloc]
                              initWithSupportedBrands:@[@(CardBrandMada),@(CardBrandMasterCard)]
                              supportedFundSource:All
                              supportedPaymentAuthentications:@[@(SupportedPaymentAuthenticationsThreeDS),@(SupportedPaymentAuthenticationsEMV)]
                              sdkMode:Sandbox];
    
    Fields* fields = [[Fields alloc] initWithCardHolder:YES];
    Addons* addons = [[Addons alloc]initWithLoader:YES
                               displayCardScanning:YES];
    Interface* interface = [[Interface alloc]initWithLocale:@"en" direction:CardDirectionDynamic edges:CardEdgesCurved tapScannerUICustomization:Nil powered:YES];
    
    TapCardDataConfiguration* cardDataConfig = [[TapCardDataConfiguration alloc]initWithPublicKey:publicKey scope:scope transcation:transaction order:order merchant:merchant customer:customer features:features acceptance:acceptance fields:fields addons:addons interface:interface];
    
    
    [TapCardForumConfiguration.shared configureWithDataConfig:cardDataConfig onCardSdkReady:^{
        NSLog(@"%@",@"Checkout is ready");
        [self.startButton setEnabled:YES];
    } onErrorOccured:^(NSError * error) {
        NSLog(@"%@ %@",@"Error :",error.localizedDescription);
    }];
}


@end
