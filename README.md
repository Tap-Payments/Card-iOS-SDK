# Tap Card iOS SDK

[](https://tap-payments.github.io/TapCardCheckOutKit)
[](https://img.shields.io/Tap-Payments/v/TapCardCheckOutKit)
[](https://tap-payments.github.io/TapCardCheckOutKit-iOS)

The Tap Card iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app. We provide powerful and customizable UI screens and elements that can be used out-of-the-box to collect your users' payment details. We also expose the low-level APIs that power those UIs so that you can build fully custom experiences.

Learn about our [Tap Identity Authentication](https://tappayments.api-docs.io/2.0/authentication) to verify the identity of your users on iOS.

Get started with our [documentation guide](https://www.tap.company/eg/en/developers) and [example projects](https://github.com/Tap-Payments/TapCardCheckOutKit/tree/main/TapCardCheckOutKit/TapCardCheckoutExample.)

Table of contents

- [Features](https://github.com/Tap-Payments/TapCardCheckOutKit#features)
- [3DS Secure](https://github.com/Tap-Payments/TapCardCheckOutKit#3DSSecure)
- [Native UI](https://github.com/Tap-Payments/TapCardCheckOutKit#NativeUI)
- [Card Scanning](https://github.com/Tap-Payments/TapCardCheckOutKit#CardScanning)
- [Installation](https://github.com/Tap-Payments/TapCardCheckOutKit#Installation)
- [Data Configuration](https://github.com/Tap-Payments/TapCardCheckOutKit#DataConfig)
- [Single line code initilization](https://github.com/Tap-Payments/TapCardCheckOutKit#SLC)

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
  
  - <img width="1078" alt="Screen Shot 2022-08-28 at 7 57 41 PM" src="https://user-images.githubusercontent.com/59433049/187088292-89b7552e-1b2e-48c3-90fc-2928983446cb.png">

    
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
