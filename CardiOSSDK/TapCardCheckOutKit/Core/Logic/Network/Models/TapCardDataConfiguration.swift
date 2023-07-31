//
//  TapCardDataConfiguration.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation
import CommonDataModelsKit_iOS
import LocalisationManagerKit_iOS
import BugfenderSDK
import TapCardVlidatorKit_iOS
import TapCardScanner_iOS

/// The datasource configiation required so the card kit can perform Init call api
@objc public class TapCardDataConfiguration: NSObject {
    
    /**
     Card configuration model to customize the logic and ui/ux of the tap card element
     - Parameter publickKey : The public keys providede to your business from Tap integration team.
     - Parameter scope: An enum to define the required scope of the tap card sdk. Default is to generate Tap Token for the card
     - Parameter transaction: A model that represents the amount and the currency combined. Default is 1 KWD
     - Parameter merchant: A model that represents the details and configurations related to the merchant. Including your merchant id provided by Tap integration team
     - Parameter customer: Represents the model for the customer if any.
     - Parameter acceptance: A model that represents the details of the acceptance levels and payment methods. Like, payment methods, payment brands, types of allowed cards etc. Default is to accept all allowed payment methods activiated to your business from Tap integration team.
     - Parameter fields: Defines which card fields you want to show/hide. Currently, only card name is controllable and default is true.
     - Parameter addons: A model that decides the visibilty of some componens related to the card sdk. So the merchant can adjust the UX as much as possible to fit his UI
     - Parameter interface: A model of parameters that controls a bit the look and feel of the card sdk.
     */
    @objc public init (publicKey:SecretKey, scope: Scope = .TapToken, transcation: Transaction = .init(), merchant: Merchant, customer: TapCustomer = TapCustomer.defaultCustomer(), acceptance: Acceptance = .init(), fields: Fields = .init(), addons: Addons = .init(), interface: Interface = .init()) {
        super.init()
        self.publicKey = publicKey
        self.enableLogging = [.CONSOLE]
        self.scope = scope
        self.customer = customer
        self.merchant = merchant
        self.acceptance = acceptance
        self.fields = fields
        self.addons = addons
        self.interface = interface
        configureBugFinder()
    }
    
    
    // MARK: Public shared values
    
    
    
    // MARK: - Private shared values
    /// The public keys providede to your business from Tap integration team.
    internal var publicKey:SecretKey = .init(sandbox: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp")
    /// An enum to define the required scope of the tap card sdk. Default is to generate Tap Token for the card
    internal var  scope: Scope = .TapToken
    /// A model that represents the amount and the currency combined. Default is 1 KWD
    internal var transcation: Transaction = .init()
    /// A model that represents the details and configurations related to the merchant. Including your merchant id provided by Tap integration team
    internal var merchant: Merchant = .init()
    /// Represents the model for the customer if any.
    internal var customer: TapCustomer = TapCustomer.defaultCustomer()
    /// A model that represents the details of the acceptance levels and payment methods. Like, payment methods, payment brands, types of allowed cards etc. Default is to accept all allowed payment methods activiated to your business from Tap integration team.
    internal var acceptance: Acceptance = .init() {
        didSet{
            SharedCommongDataModels.sharedCommongDataModels.sdkMode = acceptance.sdkMode
            SharedCommongDataModels.sharedCommongDataModels.allowedCardTypes = [CardType(cardType: acceptance.supportedFundSource)]
        }
    }
    /// Defines which card fields you want to show/hide. Currently, only card name is controllable and default is true.
    internal var fields: Fields = .init()
    /// A model that decides the visibilty of some componens related to the card sdk. So the merchant can adjust the UX as much as possible to fit his UI
    internal var addons: Addons = .init()
    /// A model of parameters that controls a bit the look and feel of the card sdk.
    internal var interface: Interface = .init() {
        didSet{
            TapLocalisationManager.shared.localisationLocale = interface.locale
        }
    }
    
    
    /// Configures and start sthe session with the bug finder logging platform
    internal func configureBugFinder() {
        // Log session start
        Bugfender.activateLogger("5P1I02VkdB1QnvUC0bPcRaeA6MZ5sWCj")
        Bugfender.enableCrashReporting()
        Bugfender.setPrintToConsole(enableLogging.contains(.CONSOLE))
        logBF(message: "New Session", tag: .EVENTS)
        if enableLogging.contains(.UI) {
            Bugfender.enableUIEventLogging()
        }
        
    }
    
    /**
     Sends a message to the logging platform
     - Parameter message: The message to be dispatched
     - Parameter tag: The tag identigyin the category
     */
    internal func logBF(message:String?, tag:TapLoggingType) {
        // Validate the message
        guard let message = message else { return }
        // Decide the level based on the logging type
        let level:BFLogLevel = (tag == .EVENTS) ? .trace : .default
        // Check if the user allowed to log this type
        guard (tag == .EVENTS && enableLogging.contains(.EVENTS)) || (tag == .API && enableLogging.contains(.API)) else { return }
        // Log it happily :)
        bfprint(message, tag: tag.stringValue, level: level)
    }
    
    /// Defines which level of logging do you wnt to enable.
    internal var enableLogging:[TapLoggingType] = [.CONSOLE]
    
    /// Metdata object will be a representation of [String:String] dictionary to be used whenever such a common model needed
    internal var metadata:TapMetadata? = nil
    /// Should we always ask for 3ds while saving the card. Default is true
    internal var enfroce3DS:Bool  {
        acceptance.supportedPaymentAuthentications.contains(.ThreeDS)
    }
    /// Holding the latest init response model to fetch requierd data when needed like session token or encryption key
    internal var sdkSettings:SDKSettings?
    /// Holding the allowed card brands to process for the logged in merchant
    internal var paymentOptions:[PaymentOption]?
    
    /// Holding the latest Init response from the middleware
    internal var initModelResponse: TapInitResponseModel?
    
    /// Holding the latest look up response from the middleware
    internal var tapBinLookUpResponse: TapBinResponseModel?
    
    /// Holding the latest card verify response from the middleware
    internal var cardVerify: TapCreateCardVerificationResponseModel?
    
    /// a block to eecute upon card save is done
    internal var onResponeSaveCardReady: (TapCreateCardVerificationResponseModel) -> () = {_ in}
    
    /// a block to eecute upon card save fails
    internal var onErrorSaveCardOccured: (Error?,TapCreateCardVerificationResponseModel?)->() = { _,_ in}
}


//MARK: Enums
/// An enum to define the required scope of the tap card sdk
@objc public enum Scope: Int {
    /// This means, that the expected functionality of the tap card sdk is to generate a tap token for the customer's card
    case TapToken
}
/// An enum to state the different allowed authentication techniques
@objc public enum SupportedPaymentAuthentications:Int {
    /// The threeD authentications provided by the banks
    case ThreeDS
    /// To be used only when using union pay cards inside China
    case EMV
}


/// An enum to state the shape aof the card's edge
@objc public enum CardEdges:Int, CaseIterable {
    /// The cad view will have a cornered radius
    case Curved
    /// To card view will have a rectangular shape
    case Straight
    
    /// a string representtion for the card edges enm cases
    public var toString:String {
        switch self {
        case .Curved:
            return "Curved"
        case .Straight:
            return "Straight"
        }
    }
}


/// An enum to state the card input direction
@objc public enum CardDirection:Int, CaseIterable {
    /// Will be LTR in English and RTL in Arabic
    case Dynamic
    /// Will be LTR in English and Arabic
    case LTR
    
    /// a string representtion for the direction enm cases
    public var toString:String {
        switch self {
        case .Dynamic:
            return "Dynamic"
        case .LTR:
            return "LTR"
        }
    }
}


//MARK: Configuration models
/// A model that represents the amount and the currency combined
@objc public class Transaction: NSObject {
    /// The amount of the transaction. Only of use, in authorize & purchase modes Default is 1
    public var amount: Double = 1
    /// The currency you want to show the card brands that accepts it. Default is KWD
    public var currency: TapCurrencyCode = .KWD
    
    /// A model that represents the amount and the currency combined
    /// - Parameter amount: Only of use, in authorize & purchase modes Default is 1
    /// - Parameter currency: The currency you want to show the card brands that accepts it. Default is KWD
    @objc public init(amount:Double = 1, currency: TapCurrencyCode = .KWD) {
        self.amount = amount
        self.currency = currency
    }
}



/// A model that represents the details and configurations related to the merchant
@objc public class Merchant: NSObject {
    /// The tap merchant identifier.
    public var id: String = ""
    
    /// A model that represents the details and configurations related to the merchant
    /// - Parameter id: The tap merchant identifier.
    @objc public init(id:String = "") {
        self.id = id
    }
}



/// A model that represents the details of the acceptance levels and payment methods
@objc public class Acceptance: NSObject {
    /// The supported brands set by the merchant for this transaction. Default is All
    public var supportedBrands: [CardBrand] = [.americanExpress, .mada, .masterCard, .omanNet, .visa, .meeza]
    /// The supported funding source for the card payments used by the customer whether debit or credit. Default is All
    public var supportedFundSource: cardTypes = .All
    /// The supported authentications for th card used by the customer. Default is 3ds
    internal var supportedPaymentAuthentications:[SupportedPaymentAuthentications] = [.ThreeDS]
    /// The SDK mode you want to try your transactions with. Default is sandbox
    public var sdkMode:SDKMode = .sandbox
    
    /// SWIFT A model that represents the details of the acceptance levels and payment methods
    /// - Parameter supportedBrands: The supported brands set by the merchant for this transaction. Default is All
    /// - Parameter supportedFundSource: The supported funding source for the card payments used by the customer whether debit or credit. Default is All
    /// - Parameter supportedPaymentAuthentications: The supported authentications for th card used by the customer. Default is 3ds
    /// - Parameter sdkMode: The enviroment you ware performing the transaction within.
    public init(supportedBrands:[CardBrand] = [.americanExpress, .mada, .masterCard, .omanNet, .visa, .meeza], supportedFundSource: cardTypes = .All,  supportedPaymentAuthentications:[SupportedPaymentAuthentications] = [.ThreeDS], sdkMode: SDKMode = .sandbox) {
        self.supportedBrands = supportedBrands
        self.supportedFundSource = supportedFundSource
        self.supportedPaymentAuthentications = supportedPaymentAuthentications
        self.sdkMode = sdkMode
    }
    
    
    /// ObjectiveC A model that represents the details of the acceptance levels and payment methods
    /// - Parameter supportedBrands: The supported brands set by the merchant for this transaction. Default is All
    /// - Parameter supportedFundSource: The supported funding source for the card payments used by the customer whether debit or credit. Default is All
    /// - Parameter supportedPaymentAuthentications: The supported authentications for th card used by the customer. Default is 3ds
    /// - Parameter sdkMode: The enviroment you ware performing the transaction within.
    @objc public init (supportedBrands:[Int] = [CardBrand.americanExpress, CardBrand.mada, CardBrand.masterCard, CardBrand.omanNet, CardBrand.visa, CardBrand.meeza].map{ $0.rawValue }, supportedFundSource: cardTypes = .All,  supportedPaymentAuthentications:[Int] = [SupportedPaymentAuthentications.ThreeDS.rawValue], sdkMode: SDKMode) {
        self.supportedBrands = supportedBrands.compactMap{ CardBrand(rawValue: $0) }
        self.supportedFundSource = supportedFundSource
        self.supportedPaymentAuthentications = supportedPaymentAuthentications.compactMap{ SupportedPaymentAuthentications(rawValue: $0) }
        self.sdkMode = sdkMode
    }
}




/// A model that decides the visibilty of the card fields. For now, only Card name is adjustable.
@objc public class Fields: NSObject {
    /// Decides whether to show/hide the card holder name. Default is false
    public var cardHolder: Bool = false
    
    /// A model that decides the visibilty of the card fields. For now, only Card name is adjustable.
    /// - Parameter cardHolder: Decides whether to show/hide the card holder name. Default is false
    @objc public init(cardHolder:Bool = false) {
        self.cardHolder = cardHolder
    }
}



/// A model that decides the visibilty of some componens related to the card sdk. So the merchant can adjust the UX as much as possible to fit his UI
@objc public class Addons: NSObject {
    /// Decides whether to show/hide the loader on topp of the card, whever the card is doing some action (e.g. tokennizing a card.) Default is true
    public var loader: Bool = true
    /// Decides whether to show/hide the the supported card brands bar underneath the card input form. Default is true
    public var displayPaymentBrands: Bool = true
    /// Decides whether or not to show the card scanning functionality. Default is true
    public var displayCardScanning: Bool = true
    
    /// A model that decides the visibilty of some componens related to the card sdk. So the merchant can adjust the UX as much as possible to fit his UI
    /// - Parameter loader: Decides whether to show/hide the loader on topp of the card, whever the card is doing some action (e.g. tokennizing a card.) Default is true
    /// - Parameter displayPaymentBrands : Decides whether to show/hide the the supported card brands bar underneath the card input form. Default is true
    /// - Parameter displayCardScanning: Decides whether or not to show the card scanning functionality. Default is true
    @objc public init(loader:Bool = true, displayPaymentBrands: Bool = true, displayCardScanning: Bool = true) {
        self.loader = loader
        self.displayPaymentBrands = displayPaymentBrands
        self.displayCardScanning = displayCardScanning
    }
}



/// A model of parameters that controls a bit the look and feel of the card sdk.
@objc public class Interface: NSObject {
    /// Defines the locale to display the card with. accepted values en,ar and default is en
    public var locale: String = "en"
    /// Defines the direction/text alignment of the card input fields. Default is dynamic to follow the locale's alignment
    public var direction: CardDirection = .Dynamic
    /// Defines the shape aof the card’s edge. Default is curved
    public var edges: CardEdges = .Curved
    ///The ui customization to the full screen scanner borer color and to show a blur
    public var tapScannerUICustomization:TapFullScreenUICustomizer = .init()
    
    /// A model of parameters that controls a bit the look and feel of the card sdk.
    /// - Parameter locale: Defines the locale to display the card with. accepted values en,ar and default is en
    /// - Parameter displayPaymentBrands : Defines the direction/text alignment of the card input fields. Default is dynamic to follow the locale's alignment
    /// - Parameter edges: Defines the shape aof the card’s edge. Default is curved
    /// - Parameter tapScannerUICustomization: The ui customization to the full screen scanner borer color and to show a blur
    @objc public init(locale:String = "en", direction: CardDirection = .Dynamic, edges: CardEdges = .Curved, tapScannerUICustomization:TapFullScreenUICustomizer = .init()) {
        self.locale = locale
        self.direction = direction
        self.edges = edges
        self.tapScannerUICustomization = .init(tapFullScreenScanBorderColor: .green,
                                               blurCardScannerBackground: true)
    }
}
