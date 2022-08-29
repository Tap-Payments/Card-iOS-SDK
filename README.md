# Tap Card iOS SDK

[](https://tap-payments.github.io/TapCardCheckOutKit)
[](https://img.shields.io/Tap-Payments/v/TapCardCheckOutKit)
[](https://tap-payments.github.io/TapCardCheckOutKit-iOS)

The Tap Card iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app. We provide powerful and customizable UI screens and elements that can be used out-of-the-box to collect your users' payment details. We also expose the low-level APIs that power those UIs so that you can build fully custom experiences.

Learn about our [Tap Identity Authentication](https://tappayments.api-docs.io/2.0/authentication) to verify the identity of your users on iOS.

Get started with our [documentation guide](https://www.tap.company/eg/en/developers) and [example projects](https://github.com/Tap-Payments/TapCardCheckOutKit/tree/main/TapCardCheckOutKit/TapCardCheckoutExample.)

Table of contents

- [Features](https://github.com/Tap-Payments/TapCardCheckOutKit#features)
- [3DS Secure](https://github.com/Tap-Payments/TapCardCheckOutKit#3ds-secure)
- [Native UI](https://github.com/Tap-Payments/TapCardCheckOutKit#native-ui)
- [Card Scanning](https://github.com/Tap-Payments/TapCardCheckOutKit#card-scanning)
- [Installation](https://github.com/Tap-Payments/TapCardCheckOutKit#installation)
- [Data Configuration](https://github.com/Tap-Payments/TapCardCheckOutKit#data-configuration)
- [Single line code initilization](https://github.com/Tap-Payments/TapCardCheckOutKit#single-line-initialzation)
- [Optional Configurations](https://github.com/Tap-Payments/TapCardCheckOutKit#optional-configurations)
- [TapCardInputDelegate](https://github.com/Tap-Payments/TapCardCheckOutKit#tapCardInputDelegate)
- [Tokenization](https://github.com/Tap-Payments/TapCardCheckOutKit#tokenization)
- [Save Card](https://github.com/Tap-Payments/TapCardCheckOutKit#save-card)
- [Custom Theme](https://github.com/Tap-Payments/TapCardCheckOutKit#custom-theme)

## [](https://github.com/Tap-Payments/TapCardCheckOutKit#features)Features

**Simplified security**: We make it simple for you to collect sensitive data such as credit card numbers and remain PCI compliant. This means the sensitive data is sent directly to Tap instead of passing through your server.

- Drag and drop UI for card form collection. 
  
- Hide/Show supported card brands.
  
- Hide/Show card scanning capability.
  
- Change supported currency at run time.
  
- Pass a default card holder name.
  
- Enable/Disable collection card holder name.
  
- Strict accepting only Credit or Debit cards.
  
- Ability to add any localisation needed, supports EN/AR localisation by default.
  

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#3DSSecure)3DS Secure

The SDK automatically performs native **3DS Secure**. For extra fraud protection, (3DS) requires customers to complete an additional verification step with the card issuer when paying. Typically, you direct the customer to an authentication page on their bank’s website, and they enter a password associated with the card or a code sent to their phone. This process is familiar to customers through the card networks’ brand names, such as Visa Secure and Mastercard Identity Check. Watch our video for an example of an authenticated checkout flow.

https://user-images.githubusercontent.com/59433049/184438201-ab2aa0c9-7e94-422a-829c-1ccef1c50d8d.mov

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#NativeUI)Native UI

We provide native screens and elements to collect card payment details. Our card element is a prebuilt UI that combines all the steps required to collecting, validating, tokenizing and saving a card details - into a single view that displays within your UI flow.

<p align="center">
  <img src="https://user-images.githubusercontent.com/59433049/184471451-1b674818-c602-44c8-969c-b23e129806be.png" style="height:30%;width:30%;" alt="PreBuilt Card Form"/>
</p>

### Tap card API

We provide low level apis, that correspond to objects and methods in the Tap API. You can build your own entirely custom UI on top of this layer, while still taking advantage of utilities like [TapCardValidatorKit-iOS](https://github.com/Tap-Payments/TapCardVlidatorKit-iOS) to validate your user’s input.

```swift
`let validation = CardValidator.validate(cardNumber: "4242424242424242", preferredBrands: [.mada])
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#CardScanning)Card scanning

We support card scanning on iOS 13 and higher. The card scanner will try as accurately as possible to collect the card data to ease the process on the buyer. The scanner supports the following with maximum possible accuracy:

- Printed cards.
  
- Imposed cards.
  
- Vertical cards.
  

You should make sure your app is 13.0+ and you have added the **Privacy - Camera Usage Description** in the info.plist file, as follows:
![Screen Shot 20220828 at 12 55 14 PM](https://user-images.githubusercontent.com/59433049/187070546-ee1e0a36-08d1-492f-b85c-a4a648703d6c.png)

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#Installation)Installation

**Using Cocoapods**

add pod 'TapCardCheckOutKit' to your podfile

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#DataConfig)Data Configuration

You will need to configure the Tap Card KIT before using it, by providing your data. This will enable the card kit to load your merchant's data and ready to process card related operations (e.g. tokenization, authorization and charge.)

It is a must this data is passed before displaying the card kit UI component.

Import code:

```swift
import TapCardCheckOutKit
import CommonDataModelsKit_iOS
```

Configuration code:

```swift
// Create the data configuration model
// pass the needed sdk mode (sandbox or production). Optional, default is sandbox
// pass your SDK keys, which you get upon integrating with TAP.
// pass the needed localisation. Optional, default is en
let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: "en", secretKey: .init(sandbox: "sk_test_yKOxBvwq3oLlcGS6DagZYHM2", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"))
// Start the configuration process and listen for the callbacks
TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig) {
    print("All went good, you can show the card kit UI element")
} onErrorOccured: { error in
    print("Error happened :( \(error?.localizedDescription ?? "")")
}
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#SLC)Single line initialzation

- Drag and drop the `TapCardInputView` from the storyboard into your UIView as follows:
  
  - d
    
- Connect `IBOutlet` as follows:
  
  - ```swift
    /// Outlet referencing the card forum ui element
    @IBOutlet weak var tapCardForum: TapCardInputView!
    ```
    
- Init the `TapCardInputView` as follows:
  
  - ```swift
    /// Responsible for tap card forum UI element setup
    func configureCardInput() {
        // presentScannerInViewController: The UIViewController that will display the scanner into
        tapCardForum.setupCardForm(presentScannerInViewController: self)
    }
    ```
    

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#Optional)Optional Configurations

As mentioned in the section above, you can setup the `TapCardInputView` using a single line of code, which in turn will use the default values for many optional configurations parameters.

In here, we will descripe in detail what parameters you can pass to setup the `TapCardInputView`.

```swift
/*
     - Parameter locale: The locale identifer(e.g. en, ar, etc.0 Default value is en
     - Parameter collectCardHolderName: Indicates whether ot not the card form will ask for the card holder name. Default is false
     - Parameter showCardBrandsBar: Indicates whether ot not the card form will show the card brands bar. Default is false
     - Parameter showCardScanner: Indicates whether ot not the card scanner. Default is false
     - Parameter tapScannerUICustomization: The ui customization to the full screen scanner borer color and to show a blur
     - Parameter transactionCurrency: The currency you want to show the card brands that accepts it. Default is KWD
     - Parameter presentScannerInViewController: The UIViewController that will display the scanner into
     - Parameter blurCardScannerBackground: The ui customization to the full screen scanner borer color and to show a blur
     - Parameter allowedCardTypes: Decides which cards shall we accept. Default is All
     - Parameter tapCardInputDelegate: A delegate listens for needed actions and callbacks
     - Parameter preloadCardHolderName:  A preloading value for the card holder name if needed
     - Parameter editCardName: Indicates whether or not the user can edit the card holder name field. Default is true
     - Parameter showCardBrandIcon:deines whether to show the detected brand icon besides the card number instead of the placeholdder
     */
func setupCardForm(locale:String = "en",
                                    collectCardHolderName:Bool = false,
                                    showCardBrandsBar:Bool = false,
                                    showCardScanner:Bool = false,
                                    tapScannerUICustomization:TapFullScreenUICustomizer = .init(),
                                    transactionCurrency:TapCurrencyCode = .KWD,
                                    presentScannerInViewController:UIViewController?,
                                    allowedCardTypes:cardTypes = .All,
                                    tapCardInputDelegate:TapCardInputDelegate? = nil,
                                    preloadCardHolderName:String = "",
                                    editCardName:Bool = true,
                                    showCardBrandIcon:Bool = true)
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#Delegate)TapCardInputDelegate

The delegate allows data to flow from the card kit into the parent app as follows:

```swift
extension ViewController: TapCardInputDelegate {
    /**
     Be updated by listening to events fired from the card kit
     - Parameter with event: The event just fired
     */
    func eventHappened(with event: CardKitEventType) {
        switch event {
        case .CardNotReady:
            print("This means the user didn't enter a valid card data yet.")
        case .CardReady:
            print("This means the user entered a valid card data.")
        case .TokenizeStarted:
            print("The card kit started tokenizing the entered card data.")
        case .TokenizeEnded:
            print("The card kit ended tokenizing the entered card data.")
        case .SaveCardStarted:
            print("The card kit started saving the entered card data.")
        case .SaveCardEnded:
            print("The card kit ended saving the entered card data.")
        case .ThreeDSStarter:
            print("The 3DS process started while saving a card.")
        case .ThreeDSEnded:
            print("The 3DS process ended while saving a card.")
        }
    }
    
    /**
      Listen to errors occured at run time during a process
     - Parameter with event: The event just fired
     */
    func errorOccured(with error: CardKitErrorType, message:String) {
        switch error {
        case .Network:
            print("Network error")
        case .InvalidCardType:
            print("Card type error")
        }
    }
}
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#tokenization)Tokenization

Tokenization is the process Tap uses to collect sensitive card details, directly from your customers in a secure manner. A Token representing this information is returned to your server to use to create a charge or authorize or save the card. This ensures that no sensitive card data touches your server and allows your integration to operate in a PCI compliant way.

Note that a token can only be used once, and within a few minutes of creation. To support multiple charges, future charges, or authorize, save the card token instead of charging it.

You can use this token id in the Charge or Authorize API request. Also you can use this token id in the Create Card API to save the card for future [charges](https://tappayments.api-docs.io/2.0/api/charges) or [authorize](https://tappayments.api-docs.io/2.0/api/authorize).

```swift
/**
    Handles tokenizing the current card data.
    - Parameter onResponeReady: A callback to listen when a token is successfully generated
    - Parameter onErrorOccured: A callback to listen when tokenization fails with error message and the validity of all the card fields for your own interest
*/
tapCardForum.tokenizeCard { token in
            print(token.card)
        } onErrorOccured: { error, cardFieldsValidity in
// error : The error message occured
// cardFieldsValidity : Holds the validity of each field in the card form
            print(error)
        }
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#save-card)Save Card

You can store multiple cards on a customer in order to charge or authorize the customer later.

**Note:** Token id and Customer id are required to store the cards. Save Card feature is not enabled by default, Please contact our support team to get enabled.

**Usage of Saved Card**

Saved card id, cannot be used in the charge or authorize API request. First you need to create the token id for this saved card, and then you can use this token id in the charge or authorize API request. 

Please [click here](https://tappayments.api-docs.io/2.0/cards), go to the Cards section

```swift
/**
     Handles tokenizing the current card data.
     - Parameter customer: The customer to save the card with.
     - Parameter parentController: The parent controller will be used to present the web view whenever a 3DS is required to save the card details
     - Parameter metadata: Metdata object will be a representation of [String:String] dictionary to be used whenever such a common model needed
     - Parameter enforce3DS: Should we always ask for 3ds while saving the card. Default is true
     - Parameter onResponeReady: A callback to listen when a the save card is finished successfully. Will provide all the details about the saved card data
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     - Parameter on3DSWebViewWillAppear: A callback to tell the consumer app the 3ds web view will start
     - Parameter on3DSWebViewDismissed: A callback to tell he consumer app the 3ds web view is over
     */
tapCardForum.saveCard(customer: customer, parentController: self, metadata: [:]) { [weak self] card in
            print("Card saved \(card.card.lastFourDigits)\n\(card.identifier)")
        } onErrorOccured: { [weak self] error, card, cardFieldsValidity in
            if let error = error {
                print("Error \(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
            }else if let card = card,
                     let response = card.response,
                     let message = response.message,
                     let errorCode = response.code {
                print("Card save status \(card.status.stringValue) message: Backend error message : \(message)\nWith code : \(errorCode)")
            }
        }
```

### [](https://github.com/Tap-Payments/TapCardCheckOutKit#custom-theme)Custom Theme

We made sure that as an UI element, you can customize the look and feel of it to match your own app's UX. The `theme` is represented a `JSON` data used to render the elements in light and dark modes. If not passed, the default tap theme will be used.

**Custom local theme**

You can provide `TapCardInput` UI element with a custom local theme. The local theme will be in the form of a JSON file.

```swift

/**
     Represents a model to pass custom dark and light theme files if required.
     - Parameter lightModeThemeFileName: The name of the light mode theme you file in your project you want to use. It is required
     - Parameter darkModeThemeFileName:  The name of the dark mode theme you file in your project you want to use. If not passed, the light mode one will be used for both displays
     - Parameter themeType:  Represents the type of the provided custom theme, whether it is local embedded or a remote JSON file
     */

TapCardForumConfiguration.shared.customTheme = .init(with: "CustomLightTheme", and: "CustomDarkTheme", from: .LocalJsonFile)
```

Things to note:

- Make sure the file is in your project directory.
  
- Make sure the file is following this [format](https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/LightTheme.json?alt=media&token=4f58decf-6e60-4053-bc1d-92794f39de13).
  
- For reference these are our default values for [light](https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/LightTheme.json?alt=media&token=4f58decf-6e60-4053-bc1d-92794f39de13) and [dark](https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/DarkTheme.json?alt=media&token=e6f51e9f-4101-4d10-8a47-86c0c193b54d) modes.
  
- Light mode is mandatory.
  
- Dark mode is optional, if not passed then light mode will be used in both display modes.
  

**Custom remote theme**

You can provide `TapCardInput` UI element with a custom remote theme. The remote theme will be in the form of a JSON file. Giving you the capability to change the look & feel online without the need to update your app.

```swift
/**
     Represents a model to pass custom dark and light theme files if required.
     - Parameter lightModeThemeFileName: The name of the light mode theme you file in your project you want to use. It is required
     - Parameter darkModeThemeFileName:  The name of the dark mode theme you file in your project you want to use. If not passed, the light mode one will be used for both displays
     - Parameter themeType:  Represents the type of the provided custom theme, whether it is local embedded or a remote JSON file
     */

.init(with: "https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/LightTheme.json?alt=media&token=4f58decf-6e60-4053-bc1d-92794f39de13",
                      and: "https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/DarkTheme.json?alt=media&token=e6f51e9f-4101-4d10-8a47-86c0c193b54d",
                      from: .RemoteJsonFile)
```

Things to note:

- Make sure the file is in your project directory.
  
- Make sure the file is following this [format](https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/LightTheme.json?alt=media&token=4f58decf-6e60-4053-bc1d-92794f39de13).
  
- For reference these are our default values for [light](https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/LightTheme.json?alt=media&token=4f58decf-6e60-4053-bc1d-92794f39de13) and [dark](https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/DarkTheme.json?alt=media&token=e6f51e9f-4101-4d10-8a47-86c0c193b54d) modes.
  
- Light mode is mandatory.
  
- Dark mode is optional, if not passed then light mode will be used in both display modes.
