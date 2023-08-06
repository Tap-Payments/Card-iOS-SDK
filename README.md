# Card iOS SDK

[](https://tap-payments.github.io/TapCardCheckOutKit)
[](https://img.shields.io/Tap-Payments/v/TapCardCheckOutKit)
[](https://tap-payments.github.io/TapCardCheckOutKit-iOS)

The Tap Card iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app. We provide powerful and customizable UI screens and elements that can be used out-of-the-box to collect your users' payment details. We also expose the low-level APIs that power those UIs so that you can build fully custom experiences.

Learn about our [Tap Identity Authentication](https://tappayments.api-docs.io/2.0/authentication) to verify the identity of your users on iOS.

Get started with our [documentation guide](https://www.tap.company/eg/en/developers) and [example projects](https://github.com/Tap-Payments/TapCardCheckOutKit/tree/main/TapCardCheckOutKit/TapCardCheckoutExample.)

Table of contents

- [Features](https://github.com/Tap-Payments/TapCardCheckOutKit#features)
- [Card Scanning](https://github.com/Tap-Payments/TapCardCheckOutKit#card-scanning)
- [Installation](https://github.com/Tap-Payments/TapCardCheckOutKit#installation)
- [Data Configuration](https://github.com/Tap-Payments/TapCardCheckOutKit#DataConfig)
  - [PublicKey](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectPublicKey)
  - [Scope](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectScope)
  - [Transaction](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectTransaction)
  - [Order](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectOrder)
  - [Merchant](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectMerchant)
  - [Customer](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectCustomer)
  - [Features](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectFeatures)
  - [Acceptance](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectAcceptance)
  - [Fields](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectFields)
  - [Addons](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectAddons)
  - [Interface](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectInterface)
- [Passing Configurations](https://github.com/Tap-Payments/TapCardCheckOutKit#PassConfig)
- [Add Card View](https://github.com/Tap-Payments/TapCardCheckOutKit#CardView)
- [Card View Delegate](https://github.com/Tap-Payments/TapCardCheckOutKit#CardViewDelegate)
- [Tokenize](https://github.com/Tap-Payments/TapCardCheckOutKit#Tokenize)
- [Full code example](https://github.com/Tap-Payments/TapCardCheckOutKit#Example)

## [](https://github.com/Tap-Payments/TapCardCheckOutKit#features)Features

**Simplified security**: We make it simple for you to collect sensitive data such as credit card numbers and remain PCI compliant. This means the sensitive data is sent directly to Tap instead of passing through your server.

- Drag and drop UI for card form collection. 
  
- Hide/Show supported card brands.
  
- Hide/Show card scanning capability.
  
- Pass a default card holder name.
  
- Enable/Disable collection of card holder name.
  
- Accept only Credit or Debit cards.
  
- Define which card brands to be allowed.
  
- Choose Enligsh and Arabic layouts.
  
- Auto detect the device's display style supporting light and dark ones.
  

### Tap card API

We provide low level apis, that correspond to objects and methods in the Tap API. You can build your own entirely custom UI on top of this layer, while still taking advantage of utilities like [TapCardValidatorKit-iOS](https://github.com/Tap-Payments/TapCardVlidatorKit-iOS) to validate your user’s input.

```swift
let validation = CardValidator.validate(cardNumber: "4242424242424242", preferredBrands: [.mada])
```

## [](https://github.com/Tap-Payments/TapCardCheckOutKit#CardScanning)Card scanning

We support card scanning on iOS 13 and higher. The card scanner will try as accurately as possible to collect the card data to ease the process on the buyer. The scanner supports the following with maximum possible accuracy:

- Printed cards.
  
- Imposed cards.
  
- Vertical cards.
  

You should make sure your app is 13.0+ and you have added the **Privacy - Camera Usage Description** in the info.plist file, as follows:
![Screen Shot 20220828 at 12 55 14 PM](https://user-images.githubusercontent.com/59433049/187070546-ee1e0a36-08d1-492f-b85c-a4a648703d6c.png)

## [](https://github.com/Tap-Payments/TapCardCheckOutKit#Installation)Installation

**Using Cocoapods**

add pod 'TapCardCheckOutKit' to your podfile

## [](https://github.com/Tap-Payments/TapCardCheckOutKit#DataConfig)Usage

<div>
<img src='https://tap-assets.b-cdn.net/svgviewer-output.svg' title='CardIosSDK' /></a>
</div>

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectConfiguration)Define Card Configurations (1)

#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectPublicKey)Define Public key (1.1)

The public keys providede to your business from Tap integration team. They are used to correctly identify your identity as a Tap merchant. You can always test with out testing keys, but to get your own please [Sign up](https://register.tap.company/en)

##### Code samples:

```swift
var publicKey:SecretKey = .init(sandbox: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp")
```

```c
CheckoutSecretKey* publicKey = [[CheckoutSecretKey alloc]initWithSandbox:@"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7" production:@"sk_live_V4UDhitI0r7sFwHCfNB6xMKp"];
```

#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectScope)Define Scope(1.2)

An enum to define the required scope of the tap card sdk. Default is to generate Tap Token for a card. Keep an eye, while we add more scopes to our sdks.

##### Code samples:

```swift
var  scope: Scope = .TapToken
```

```c
Scope* scope = ScopeTapToken
```

#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectTransaction)Define Transaction(1.3)

A model that represents the amount and the currency combined, for your targeted transaction. Default is 1 KWD

##### Code samples:

```swift
var transcation: Transaction = .init(amount:Double = 1, currency: TapCurrencyCode = .KWD)
```

```c
Transaction transaction = [[Transaction alloc]initWithAmount:1 currency:TapCurrencyCodeKWD];
```


#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectOrder)Define Order(1.4)

A  model that represents the reference to Tap order if needed

##### Code samples:

```swift
var order: Order = .init(identifier: "")
```

```c
CheckoutOrder* order = [[CheckoutOrder alloc]initWithIdentifier:@""];
```

#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectMerchant)Define Merchant(1.4)

A model that represents the details and configurations related to the merchant. Including your merchant id provided by Tap integration team.

##### Code samples:

```swift
var merchant: Merchant = .init(id:"ID")
```

```c
Merchant* merchant = [[Merchant alloc]initWithId:@"ID"];
```

#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectCustomer)Define Customer(1.5)

Represents the model for the customer attached to the transaction if any.

##### Code samples:

```swift
// If you know the customer id
var customer:TapCustomer = TapCustomer(identifier: "Customer ID",
                                       nameOnCard: "Cardholder name",
                                       editable: true)

// If you want to create a new customer object
var customer: try! TapCustomer(emailAddress: .init(emailAddressString: "tap@company.com"),
                         phoneNumber: .init(isdNumber: "965", phoneNumber: "22922822"),
                         firstName: "First name", middleName: "Not needed",
                         lastName: "Last Name",
                         address: nil,
                         nameOnCard: "Customer's card holder name",
                         editable: true)
```

```c
TapCustomer* customer = [[TapCustomer alloc]initWithEmailAddress:[[TapEmailAddress alloc] initWithEmailAddressString:@"tap@company.com"]
                                                         phoneNumber:[[TapPhone alloc]initWithIsdNumber:@"" phoneNumber:@"" error:nil]
                                                           firstName:@"First Name"
                                                          middleName:@"Not Needed"
                                                            lastName:@"Last Name"
                                                             address:nil
                                                          nameOnCard:@"Customer's card holder name"
                                                            editable:YES];
```

##### Customer's parameters documentation:

| Parameter | Description | Required | Sample |
| --- | --- | --- | --- |
| identifier | Customer's tap identifier. You can get it through tap apis. Usually, you will get when the customer makes a transaction. | Required if you are not passing email or phone. SO whether you provide email or phone or identifier. | `"CustomerID"` |
| emailAddress | The email address for the new customer. | Required if you are not passing an identifier or a phone. | `.init( emailAddressString : "tap@company.com")` |
| phoneNumber | The phone number for the new customer. | Required if you are not passing an identifier or an email. | `.init( isdNumber : "965" , phoneNumber : "22922822" )` |
| firstName | The new customer's first name. | Required if you are creating a new customer. | `"Name"` |
| middleName | The new customer's middle name. | Optional, default is **""** | `"Name"` |
| lastName | The new customer's last name | Optional, default is **""** | `"Name"` |
| address | The customer's address. | Optional. | `let country:Country = try! .init(isoCode: "KW")<br/> let adddress:Address = .init(type:.commercial,<br/> country: country,<br/> line1: "8 mall",<br/> line2: "floor 6",<br/> line3: "Salem Al Mubarak St",<br/> city: "Salmiya",<br/> state: "Hawally",<br/> zipCode: "30003"<br/>)` |
| nameOnCard | If you want to fill the card holder name field in the card form. | Optional, Default is **""** | `"Card holder name"` |
| editable | If you want to make the card holder name editable or not. | Optional, Default is **TRUE** | `"true"` |


#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectFeatures)Define Features (1.7)

A model that decides the enablement of some of teh Tap provided features related to UI/UX

##### Code samples:

```swift
/// A model that decides the enablement of some of teh Tap provided features related to UI/UX
    /// - Parameter acceptanceBadge : Decides whether to show/hide the the supported card brands bar underneath the card input form. Default is true
    var features: Features = .init(acceptanceBadge: true)
```

```c
Features* features = [[Features alloc] initWithAcceptanceBadge:YES];
```


#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectAcceptance)Define Acceptance(1.6)

Represents the details of the acceptance details, like payment methods, transaction's environment, card types, etc. Default is to accept all allowed payment methods activiated to your business from Tap integration team.

##### Code samples:

```swift

var acceptance: Acceptance = .init(supportedBrands: [.mada,.masterCard],
                                       supportedFundSource: .All,
                                       supportedPaymentAuthentications:
                                        [.ThreeDS, .EMV],
                                       sdkMode: .sandbox)
```

```objc
Acceptance* acceptance = [[Acceptance alloc]
                              initWithSupportedBrands:@[@(CardBrandMada),@(CardBrandMasterCard)]
                              supportedFundSource:All
                              supportedPaymentAuthentications:@[@(SupportedPaymentAuthenticationsThreeDS),@(SupportedPaymentAuthenticationsEMV)]
                              sdkMode:Sandbox];
```

##### Acceptance's parameters documentation:

| Parameter | Description | Required | Sample |
| --- | --- | --- | --- |
| supportedBrands | The supported brands / payment methods. Default is **All** | NO  | `[.americanExpress, .mada, .masterCard, .omanNet, .visa, .meeza]` |
| supportedFundSource | The supported funding source for the card whether debit or credit. Default is **All** | NO  | `.All` or `.Credit` or `.Debit` |
| supportedPaymentAuthentications | The supported authentications for th card. Default is **3ds** | NO  | A combination of <br/>`ThreeDS` & `EMV` |
| sdkMode | The SDK mode you want to try your transactions with. Default is **sandbox** | Yes | Any of `.sanbox` or `.production` |

#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectFields)Define Fields (1.7)

A model that decides the visibilty of the card fields. For now, only Card name is adjustable.

##### Code samples:

```swift
/// - Parameter cardHolder: Decides whether to show/hide the card holder name.
/// Default is false
var fields: Fields = .init(cardHolder: true)
```

```c
Fields* fields = [[Fields alloc] initWithCardHolder:YES];
```

#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectAddons)Define Addons (1.8)

A model that decides the visibilty of some componens related to the card sdk. So the merchant can adjust the UX as much as possible to fit your UI.

##### Code samples:

```swift
var addons: Addons = .init(loader: true,
                           displayCardScanning: true)
```

```c
Addons* addons = [[Addons alloc]initWithLoader:YES
                               displayCardScanning:YES];
```

##### Addon's parameters documentation:

| Parameter | Description | Required | Sample |
| --- | --- | --- | --- |
| loader | Decides whether to show/hide the loader on topp of the card, whever the card is doing some action (e.g. tokennizing a card.) Default is **true** | NO  | true |
| displayCardScanning | Decides whether or not to show the card scanning functionality. Default is **true** | NO  | true |

#### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectInterface)Define Interface (1.9)

A model of parameters that controls a bit the look and feel of the card sdk.

##### Code samples:

```swift
var interface: Interface = .init(locale: "en",
                                 direction: .Dynamic,
                                 edges: .Curved,
                                 tapScannerUICustomization: .init(tapFullScreenScanBorderColor: .green,
                                                                  blurCardScannerBackground: true),
                                 powered: true)
```

```c
Interface* interface = [[Interface alloc]initWithLocale:@"en"
                        direction:CardDirectionDynamic
                        edges:CardEdgesCurved
                        tapScannerUICustomization: nil
                        powered: YES];
```

##### Interface's parameters documentation:

| Parameter | Description | Required | Sample |
| --- | --- | --- | --- |
| locale | Defines the locale to display the card with. accepted values en,ar and default is **en** | NO  | `en` |
| direction | Defines the direction/text alignment of the card input fields. Default is **dynamic** to follow the locale's alignment | NO  | `.LTR` or `.Dynamic` |
| edges | Defines the shape aof the card’s edge. Default is **curved** | NO  | `.curved` or `.straight` |
| tapScannerUICustomization | The ui customization to the full screen scanner borer color and to show a blur. Default is `green` & `blur`. | NO  | `.init( tapFullScreenScanBorderColor : .green , <br/>blurCardScannerBackground : true )` |
| powered | Display the powered by tap logo. Default is **true** | NO  | `true` or `false` |

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#PassConfig)Pass configurations to Card SDK (2)

After collecting/defining the [configurations](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectConfiguration), now it is time to pass these configurations to the Card sdk. Please mind the following:

1. Always run the configuration interface before you show the screen that has the card element.
  
2. This ensures the card element will look and behave as expected.
  
3. This ensures you validate the configurations before proceeding further with your checkout screen.
  

##### Code samples:

```swift
// Pass the configuration to the static card configuration.
// Ask the card to configure itself and listen to the call backs
TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig) {
            // This means, the card is correctly configured and the
// transaction data you passed are valid.
// Now you can proceed to the screen that contains your card view.
        } onErrorOccured: { error in
            // This means, an error happened in the configurations you passed.
// For example, passing a currency/payment method not enabled to you as a
// merchant.
        }
```

```c
// Pass the configuration to the static card configuration.
// Ask the card to configure itself and listen to the call backs
[TapCardForumConfiguration.shared configureWithDataConfig:cardDataConfig onCardSdkReady:^{
                    // This means, the card is correctly configured and the
// transaction data you passed are valid.
// Now you can proceed to the screen that contains your card view.
    } onErrorOccured:^(NSError * error) {
                    // This means, an error happened in the configurations you passed.
// For example, passing a currency/payment method not enabled to you as a
// merchant.
    }];
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CardView)Show you screen with the Tap Card View (3)

You can add the `TapCardView` as a drag drop into your `UIViewController` in the `Storyboard`.

1. Add a `UIView` .
  
2. Set it to have edge to edge `width`.
  
3. Set its `height` to `158` with a `low` priority.
  
4. Change the `UIView` class in the inspector to `TapCardView` & make sure Module field is `TapCardCheckOutKit`
  
5. Add an `IBOutlet` to your `UIViewController` for further access.
  
  1. ```swift
    @IBOutlet weak var tapCardView: TapCardView!
    ```
    

![](https://i.ibb.co/nRBrknV/Screenshot-2023-07-29-at-10-18-02-AM.png)

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CardViewSetup)Setup Tap Card View (4)

Now, we will have to set the delegate to the `TapCardView`. This will help you listening and being notified about different events, that happens at run time during customer's interaction with the card sdk.

##### Code samples:

```swift
/**
 - Parameter presentScannerInViewController: The UIViewController that will display the scanner into
 - Parameter tapCardInputDelegate: A delegate listens for needed actions and callbacks
*/
tapCardView.setupCardForm(presentScannerInViewController: self, tapCardInputDelegate: self)
```

```c
/**
 - Parameter presentScannerInViewController: The UIViewController that will display the scanner into
 - Parameter tapCardInputDelegate: A delegate listens for needed actions and callbacks
*/
[_tapCardView setupCardFormWithPresentScannerInViewController:self tapCardInputDelegate:self];
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CardViewDelegate)Tap Card Delegate (5)

We assigned the controller to be the [delegate](https://github.com/Tap-Payments/TapCardCheckOutKit#CardViewSetup). Let us see the two methods provided insde the delegate

Before we look into listening to the delegate methods, it is important to get used to two different important enums.

##### CardKitErrorType:

This enum will be passed in the `errorOccured` delegate method.

Possible values:

1. `Network` : This means, for some reaon, TAP servers are not reachable. So you may want to tell your customer to check his connection and try again in a while.
  
2. `InvalidCardType` : This means, your customer is trying to pay with unallowed brand/type other than the ones you allowed in your [configurations](https://github.com/Tap-Payments/TapCardCheckOutKit#CollectConfiguration) . For example, we detected he is paying with a `Credit` card while you only resitriced acceptance for `Debit` . So it is the time you can show an educational message to your customer.
  

##### CardKitEventType:

Enum defining different events passed from card kit. Will help you in controlling your UI based on the different statuses of the card element at run time, based on the customer's interaction.

Possible values:

1. `CardNotReady`: Will be fired, when the card has no valid data. Meaning, you cannot tokenize the current data. This will be helpful for you in showing warning messages or to disable the checkout button.
  
2. `CardReady`: Will be fired, when the card has valid data. Meaning, you can tokenize the current data. This will be helpful for you to enable your checkout button for example.
  
3. `TokenizeStarted`: Will be fired, once the tokenization process started. It will help you in showing your own loader for example.
  
4. `TokenizeEnded` : Will be fired, once the tokenization process ended. You may proceed to checkout screen or remove your custom loader, etc.
  

##### Code samples:

```swift
extension YourViewContoller: TapCardInputDelegate {
    /**
     Will be called whenever an error occured during processing the transaction.
     - Parameter error: The error type whether it is related to network or to card.
     - Parameter message: A descriptive message to indicate what happened during the error
     */
    func errorOccured(with error: CommonDataModelsKit_iOS.CardKitErrorType, message: String) {
        // Based on the error, you may want to inform your customer and educate him
    }
    /**
     Be updated by listening to events fired from the card kit
     - Parameter with event: The event just fired
     */
    func eventHappened(with event: CommonDataModelsKit_iOS.CardKitEventType) {
        // Based on the event, you can adjust your UI like enable/disable
// The checkout button
    }
}
```

```c
@interface YourViewContoller () <TapCardInputDelegate>
    /**
     Will be called whenever an error occured during processing the transaction.
     - Parameter error: The error type whether it is related to network or to card.
     - Parameter message: A descriptive message to indicate what happened during the error
     */
- (void)errorOccuredWith:(enum CardKitErrorType)error message:(NSString * _Nonnull)message {
    // Based on the error, you may want to inform your customer and educate him
}
    /**
     Be updated by listening to events fired from the card kit
     - Parameter with event: The event just fired
     */
- (void)eventHappenedWith:(enum CardKitEventType)event {
    // Based on the event, you can adjust your UI like enable/disable
    // The checkout button
}
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#Tokenize)Generate Tap Token (6)

Now, when you recieve `CardReady` event in the [delegate](https://github.com/Tap-Payments/TapCardCheckOutKit#CardViewDelegate) , you may use the public interface provided by the Card sdk to generate a `Tap token` for the card data. You may then use this `token` to create a [Charge](https://developers.tap.company/reference/create-a-charge) or an [Authorize](https://developers.tap.company/reference/create-an-authorize).

##### Code samples:

```swift
// In your code
func tokenizeClicked() {
    // Always as a defensive coding, make sure the card can start tokenization
    // by using our validation interface
    guard tapCardView.canProcessCard() else { return }
    // This means, we can start the tokenization process
    /**
     Handles tokenizing the current card data.
     - Parameter onTokenReady: A callback to listen when a token is 
        successfully generated
     - Parameter onErrorOccured: A callback to listen when tokenization
        fails with error message and the validity of all the card
        fields for your own interest
     */
    tapCardView.tokenizeCard { [weak self] token in
            print(token.card)
            self?.showAlert(title: "Tokenized", message: token.identifier)
        } onErrorOccured: { [weak self] error, cardFieldsValidity in
            print(error)
            self?.showAlert(title: "Error", message: "\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
        }
}
```

```c
// Always as a defensive coding, make sure the card can start tokenization
// by using our validation interface
    if([_tapCardInput canProcessCard]) {
// This means, we can start the tokenization process
/**
     Handles tokenizing the current card data.
     - Parameter onTokenReady: A callback to listen when a token is 
        successfully generated
     - Parameter onErrorOccured: A callback to listen when tokenization
        fails with error message and the validity of all the card
        fields for your own interest
     */
        [_tapCardInput tokenizeCardOnTokenReady:^(CheckoutToken * token) {
            NSLog(@"%@",[token identifier]);
        } onErrorOccured:^(NSError * error, CardFieldsValidity * cardFieldsValidity) {
            [self showAlert:@"Error" message:[NSString stringWithFormat:@"%@\nAlso, tap card indicated the validity of the fields as follows :\nNumber: %i\nExpiry: %i\nCVV: %i\nName:%i",error.localizedDescription,cardFieldsValidity.cardNumberValidationStatus,cardFieldsValidity.cardExpiryValidationStatus,cardFieldsValidity.cardCVVValidationStatus,cardFieldsValidity.cardNameValidationStatus]];
        }];
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#Example)Full code example
```swift
//
//  DirectViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 29/07/2023.
//

import UIKit
import TapCardCheckOutKit
import CommonDataModelsKit_iOS
import LocalisationManagerKit_iOS

class DirectViewController: UIViewController {
    /// The card view reference
    var tapCardView:TapCardView?
    /// The tokenize button
    var tokenizeButton:UIButton = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TapLocalisationManager.shared.localisationLocale = "en"
        view.backgroundColor = .amber
        // Do any additional setup after loading the view.
        // Setup the positiong of the card view,
        // Or you can just use drag and drop features provided by the story board
        setupTokenizeButton()
        // will create the configuration object and call the Tap apis to configure & validate the card data
        configureCardSDK()
    }
    
    
    /// will create the configuration object and call the Tap apis to configure & validate the card data
    func configureCardSDK() {
        // The card data configuration
        let cardDataConfig:TapCardDataConfiguration = .init(publicKey: sharedConfigurationSharedManager.publicKey, scope: sharedConfigurationSharedManager.scope, transcation: sharedConfigurationSharedManager.transcation, merchant: sharedConfigurationSharedManager.merchant, customer: sharedConfigurationSharedManager.customer, acceptance: sharedConfigurationSharedManager.acceptance, fields: sharedConfigurationSharedManager.fields, addons: sharedConfigurationSharedManager.addons, interface: sharedConfigurationSharedManager.interface)
        // let us use the public configure interface
        TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig) {
            DispatchQueue.main.async { [weak self] in
                // This means, all went good! time to setup the card view
                self?.view.isUserInteractionEnabled = true
                self?.setupTapCardConstraints()
                self?.setupCardView()
            }
        } onErrorOccured: { error in
            DispatchQueue.main.async { [weak self] in
                // This means, an error happened! Please check your integration
                self?.view.isUserInteractionEnabled = true
                let uiAlertController:UIAlertController = .init(title: "Error from middleware", message: error?.localizedDescription ?? "", preferredStyle: .actionSheet)
                let uiAlertAction:UIAlertAction = .init(title: "Retry", style: .destructive) { _ in
                    self?.configureCardSDK()
                }
                uiAlertController.addAction(uiAlertAction)
                self?.present(uiAlertController, animated: true)
            }
        }
    }
    /// Do any additional setup after loading the view.
    /// Setup the positiong of the card view,
    /// Or you can just use drag and drop features provided by the story board
    func setupTapCardConstraints() {
        tapCardView = .init()
        view.addSubview(tapCardView!)
        tapCardView?.translatesAutoresizingMaskIntoConstraints = false
        
        // Set it to be edge to edge to the container view
        NSLayoutConstraint(item: tapCardView!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tapCardView!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tapCardView!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 50).isActive = true
        // Set a low highet constraint
        let heightConstraint = NSLayoutConstraint(item: tapCardView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 158)
        heightConstraint.isActive = true
        heightConstraint.priority = .defaultLow
        
        tapCardView?.layoutIfNeeded()
        tapCardView?.updateConstraints()
    }
    
    func setupTokenizeButton() {
        tokenizeButton.setTitle("Tokenize", for: .normal)
        tokenizeButton.backgroundColor = .systemGray2
        
        tokenizeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tokenizeButton)
        
        // Set button constraints
        NSLayoutConstraint(item: tokenizeButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tokenizeButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: tokenizeButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: tokenizeButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
        tokenizeButton.layoutIfNeeded()
        tokenizeButton.updateConstraints()
        
        tokenizeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)


    }
    
    @objc func buttonAction(sender: UIButton!) {
        // Always as a defensive coding, make sure the card can start tokenization
        // by using our validation interface
        guard tapCardView?.canProcessCard() ?? false else { return }
        // This means, we can start the tokenization process
        /**
         Handles tokenizing the current card data.
         - Parameter onTokenReady: A callback to listen when a token is
         successfully generated
         - Parameter onErrorOccured: A callback to listen when tokenization
         fails with error message and the validity of all the card
         fields for your own interest
         */
        tapCardView?.tokenizeCard { token in
            print(token.card)
        } onErrorOccured: { error, cardFieldsValidity in
            print(error)
            print("\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
        }
    }
    
    /// Will assign the delegate of the card view
    func setupCardView() {
        tapCardView?.setupCardForm(presentScannerInViewController: self, tapCardInputDelegate: self)
        // Only make it visible after successful configuration
        tapCardView?.isHidden = false
    }
}

extension DirectViewController: TapCardInputDelegate {
    func eventHappened(with event: CardKitEventType) {
        print(event.description)
        if event == .CardNotReady {
            tokenizeButton.alpha = 0.5
            tokenizeButton.isEnabled = false
        }else if event == .CardReady {
            tokenizeButton.alpha = 1
            tokenizeButton.isEnabled = true
        }
    }
    
    func errorOccured(with error: CardKitErrorType, message:String) {
        print("\(error.description) with \(message)")
    }
}
```
