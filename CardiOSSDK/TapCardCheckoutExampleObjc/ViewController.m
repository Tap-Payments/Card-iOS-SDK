//
//  ViewController.m
//  TapCardCheckoutExampleObjc
//
//  Created by Osama Rabie on 29/08/2022.
//

#import "ViewController.h"
@import TapCardCheckOutKit;
@import CommonDataModelsKit_iOS;


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_startButton setEnabled:NO];
    
    TapCardDataConfiguration* cardDataConfig = [[TapCardDataConfiguration alloc]initWithSdkMode:Sandbox localeIdentifier:@"en" secretKey: [[SecretKey alloc]initWithSandbox:@"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7" production:@"sk_live_V4UDhitI0r7sFwHCfNB6xMKp"]];
    
    [TapCardForumConfiguration.shared configureWithDataConfig:cardDataConfig
                                                  customTheme:[[TapCardForumTheme alloc] initWith:@"CustomLightTheme" and:@"CustomDarkTheme" from: TapCardForumThemeTypeLocalJsonFile]
                                           customLocalisation:nil
                                           onCheckOutReady:^{
        NSLog(@"%@",@"Checkout is ready");
        [self.startButton setEnabled:YES];
    } onErrorOccured:^(NSError * error) {
        NSLog(@"%@ %@",@"Error :",error.localizedDescription);
    }];
    
    
    /**
     How to apply custom localistion and theming, whether from local or remote file
     // get the local file url
     NSURL* customLocalisationFileURL = [[NSBundle mainBundle] URLForResource:@"CustomLocalisation" withExtension:@"json"];
     
     [[TapCardDataConfiguration alloc]initWithSdkMode:Sandbox localeIdentifier:@"en" secretKey: [[SecretKey alloc]initWithSandbox:@"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7" production:@"sk_live_V4UDhitI0r7sFwHCfNB6xMKp"]];
     
     [TapCardForumConfiguration.shared configureWithDataConfig:cardDataConfig
     customTheme:[[TapCardForumTheme alloc] initWith:@"CustomLightTheme" and:@"CustomDarkTheme" from: TapCardForumThemeTypeLocalJsonFile] customLocalisation:[[TapCardForumLocalisation alloc]initWith:customLocalisationFileURL from:TapLocalisationTypeLocalJsonFile shouldFlip:NO localeIdentifier:@"en"] onCheckOutReady:^{
     NSLog(@"%@",@"Checkout is ready");
     [self.startButton setEnabled:YES];
     } onErrorOccured:^(NSError * error) {
     NSLog(@"%@ %@",@"Error :",error.localizedDescription);
     }];
     */
    
    
}


@end
