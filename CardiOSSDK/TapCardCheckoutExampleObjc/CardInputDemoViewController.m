//
//  CardInputDemoViewController.m
//  TapCardCheckoutExampleObjc
//
//  Created by Osama Rabie on 29/08/2022.
//

#import "CardInputDemoViewController.h"
@import TapCardCheckOutKit;
@import CommonDataModelsKit_iOS;

@interface CardInputDemoViewController () <TapCardInputDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tokenizeButton;
@property (weak, nonatomic) IBOutlet TapCardView *tapCardInput;

@end

@implementation CardInputDemoViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tapCardInput setupCardFormWithPresentScannerInViewController:self tapCardInputDelegate:self];
}
- (IBAction)tokenizeClicked:(id)sender {
    
    self.view.userInteractionEnabled = NO;
    
    
    if([_tapCardInput canProcessCard]) {
        [_tapCardInput tokenizeCardOnTokenReady:^(CheckoutToken * token) {
            NSLog(@"%@",[token identifier]);
        } onErrorOccured:^(NSError * error, CardFieldsValidity * cardFieldsValidity) {
            [self showAlert:@"Error" message:[NSString stringWithFormat:@"%@\nAlso, tap card indicated the validity of the fields as follows :\nNumber: %i\nExpiry: %i\nCVV: %i\nName:%i",error.localizedDescription,cardFieldsValidity.cardNumberValidationStatus,cardFieldsValidity.cardExpiryValidationStatus,cardFieldsValidity.cardCVVValidationStatus,cardFieldsValidity.cardNameValidationStatus]];
        }];
    }
    
    /*[_tapCardInput tokenizeCardOnResponeReady:^(Token * token) {
        [self showAlert:@"Tokenized" message:token.identifier];
    } onErrorOccured:^(NSError * error, CardFieldsValidity * cardFieldsValidity) {
        [self showAlert:@"Error" message:[NSString stringWithFormat:@"%@\nAlso, tap card indicated the validity of the fields as follows :\nNumber: %i\nExpiry: %i\nCVV: %i\nName:%i",error.localizedDescription,cardFieldsValidity.cardNumberValidationStatus,cardFieldsValidity.cardExpiryValidationStatus,cardFieldsValidity.cardCVVValidationStatus,cardFieldsValidity.cardNameValidationStatus]];
    }];*/
    
}


-(void)showAlert:(NSString*)title message:(NSString*)message {
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:OK];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)errorOccuredWith:(enum CardKitErrorType)error message:(NSString * _Nonnull)message {
    
}

- (void)eventHappenedWith:(enum CardKitEventType)event {
    switch (event) {
        case CardNotReady:
            NSLog(@"This means the user didn't enter a valid card data yet.");
        case CardReady:
            NSLog(@"This means the user entered a valid card data.");
        case TokenizeStarted:
            NSLog(@"The card kit started tokenizing the entered card data.");
        case TokenizeEnded:
            NSLog(@"The card kit ended tokenizing the entered card data.");
        default:
            NSLog(@"Other events");
    }
}

@end
