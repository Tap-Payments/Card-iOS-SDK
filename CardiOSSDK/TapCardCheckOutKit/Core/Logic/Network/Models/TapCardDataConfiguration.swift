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

/// The datasource configiation required so the card kit can perform Init call api
@objc public class TapCardDataConfiguration: NSObject {
    
    /**
     The datasource configiation required so the card kit can perform Init call api
     - Parameter sdkMode: Represents the mode of the sdk . Whether sandbox or production
     - Parameter localeIdentifier : The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
     - Parameter secretKey: The secret keys providede to your business from TAP.
     - Parameter enableApiLogging: Defines which level of logging do you wnt to enable. Please pass the raw value for the enums [TapLoggingType](x-source-tag://TapLoggingType)
     */
    @objc public init(sdkMode: SDKMode = .sandbox, localeIdentifier: String = "en", secretKey: SecretKey = .init(sandbox: "", production: ""), enableApiLogging:[Int] = [TapLoggingType.CONSOLE.rawValue]) {
        super.init()
        self.sdkMode = sdkMode
        self.localeIdentifier = localeIdentifier
        self.publicKey = secretKey
        self.enableLogging = enableApiLogging.map{ TapLoggingType(rawValue: $0) ?? .CONSOLE }
        configureBugFinder()
        SharedCommongDataModels.sharedCommongDataModels.sdkMode = sdkMode
    }
    
    
    // MARK: Public shared values
    
    
    
    // MARK: - Private shared values
    
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
    
    /// Represents the mode of the sdk . Whether sandbox or production
    internal var sdkMode:SDKMode = .sandbox{
        didSet{
            SharedCommongDataModels.sharedCommongDataModels.sdkMode = sdkMode
        }
    }
    /// Defines which level of logging do you wnt to enable.
    internal var enableLogging:[TapLoggingType] = [.CONSOLE]
    
    /// The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
    internal var localeIdentifier:String = "en"{
        didSet{
            TapLocalisationManager.shared.localisationLocale = localeIdentifier
        }
    }
    /// The secret keys providede to your business from TAP.
    internal var publicKey:SecretKey = .init(sandbox: "", production: "")
    
    /// The currency you want to show the card brands that accepts it. Default is KWD
    internal var transactionCurrency: TapCurrencyCode = .SAR
    /// The attached customer passed for this transaction (e.g. save card)
    internal var transactionCustomer: TapCustomer?
    /// Metdata object will be a representation of [String:String] dictionary to be used whenever such a common model needed
    internal var metadata:TapMetadata? = nil
    /// Should we always ask for 3ds while saving the card. Default is true
    internal var enfroce3DS:Bool = true
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
@objc public enum CardEdges:Int {
    /// The cad view will have a cornered radius
    case Curved
    /// To card view will have a rectangular shape
    case Staright
}


/// An enum to state the card input direction
@objc public enum CardDirection:Int {
    /// Will be LTR in English and RTL in Arabic
    case Dynamic
    /// Will be LTR in English and Arabic
    case LTR
}


//MARK: Configuration models
/// A model that represents the amount and the currency combined
@objc public class Transaction: NSObject {
    /// The amount of the transaction. Only of use, in authorize & purchase modes Default is 1
    internal var amount: Double = 1
    /// The currency you want to show the card brands that accepts it. Default is KWD
    internal var currency: TapCurrencyCode = .KWD
    
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
    internal var id: String = ""
    
    /// A model that represents the details and configurations related to the merchant
    /// - Parameter id: The tap merchant identifier.
    @objc public init(id:String = "") {
        self.id = id
    }
}



/// A model that represents the details of the acceptance levels and payment methods
@objc public class Acceptance: NSObject {
    /// The supported brands set by the merchant for this transaction. Default is All
    internal var supportedBrands: [CardBrand] = CardBrand.allCases
    /// The supported funding source for the card payments used by the customer whether debit or credit. Default is All
    internal var supportedFundSource: cardTypes = .All
    /// The supported authentications for th card used by the customer. Default is 3ds
    internal var supportedPaymentAuthentications:[SupportedPaymentAuthentications] = [.ThreeDS]
    
    /// SWIFT A model that represents the details of the acceptance levels and payment methods
    /// - Parameter supportedBrands: The supported brands set by the merchant for this transaction. Default is All
    /// - Parameter supportedFundSource: The supported funding source for the card payments used by the customer whether debit or credit. Default is All
    /// - Parameter supportedPaymentAuthentications: The supported authentications for th card used by the customer. Default is 3ds
    public init(supportedBrands:[CardBrand] = CardBrand.allCases, supportedFundSource: cardTypes = .All,  supportedPaymentAuthentications:[SupportedPaymentAuthentications] = [.ThreeDS] ) {
        self.supportedBrands = supportedBrands
        self.supportedFundSource = supportedFundSource
        self.supportedPaymentAuthentications = supportedPaymentAuthentications
    }
    
    
    /// ObjectiveC A model that represents the details of the acceptance levels and payment methods
    /// - Parameter supportedBrands: The supported brands set by the merchant for this transaction. Default is All
    /// - Parameter supportedFundSource: The supported funding source for the card payments used by the customer whether debit or credit. Default is All
    /// - Parameter supportedPaymentAuthentications: The supported authentications for th card used by the customer. Default is 3ds
    @objc public init (supportedBrands:[Int] = CardBrand.allCases.map{ $0.rawValue }, supportedFundSource: cardTypes = .All,  supportedPaymentAuthentications:[Int] = [SupportedPaymentAuthentications.ThreeDS.rawValue] ) {
        self.supportedBrands = supportedBrands.compactMap{ CardBrand(rawValue: $0) }
        self.supportedFundSource = supportedFundSource
        self.supportedPaymentAuthentications = supportedPaymentAuthentications.compactMap{ SupportedPaymentAuthentications(rawValue: $0) }
    }
}




/// A model that decides the visibilty of the card fields. For now, only Card name is adjustable.
@objc public class Fields: NSObject {
    /// Decides whether to show/hide the card holder name. Default is false
    internal var cardHolder: Bool = false
    
    /// A model that decides the visibilty of the card fields. For now, only Card name is adjustable.
    /// - Parameter cardHolder: Decides whether to show/hide the card holder name. Default is false
    @objc public init(cardHolder:Bool = false) {
        self.cardHolder = cardHolder
    }
}



/// A model that decides the visibilty of some componens related to the card sdk. So the merchant can adjust the UX as much as possible to fit his UI
@objc public class Addons: NSObject {
    /// Decides whether to show/hide the loader on topp of the card, whever the card is doing some action (e.g. tokennizing a card.) Default is true
    internal var loader: Bool = true
    /// Decides whether to show/hide the the supported card brands bar underneath the card input form. Default is true
    internal var displayPaymentBrands: Bool = true
    
    /// A model that decides the visibilty of some componens related to the card sdk. So the merchant can adjust the UX as much as possible to fit his UI
    /// - Parameter loader: Decides whether to show/hide the loader on topp of the card, whever the card is doing some action (e.g. tokennizing a card.) Default is true
    /// - Parameter displayPaymentBrands : Decides whether to show/hide the the supported card brands bar underneath the card input form. Default is true
    @objc public init(loader:Bool = true, displayPaymentBrands: Bool = true) {
        self.loader = loader
        self.displayPaymentBrands = displayPaymentBrands
    }
}



/// A model of parameters that controls a bit the look and feel of the card sdk.
@objc public class Interface: NSObject {
    /// Defines the locale to display the card with. accepted values en,ar and default is en
    internal var locale: String = "en"
    /// Defines the direction/text alignment of the card input fields. Default is dynamic to follow the locale's alignment
    internal var direction: CardDirection = .Dynamic
    /// Defines the shape aof the card’s edge. Default is curved
    internal var edges: CardEdges = .Curved
    
    /// A model of parameters that controls a bit the look and feel of the card sdk.
    /// - Parameter loader: Defines the locale to display the card with. accepted values en,ar and default is en
    /// - Parameter displayPaymentBrands : Defines the direction/text alignment of the card input fields. Default is dynamic to follow the locale's alignment
    /// - Parameter edges: Defines the shape aof the card’s edge. Default is curved
    @objc public init(locale:String = "en", direction: CardDirection = .Dynamic, edges: CardEdges = .Curved) {
        self.locale = locale
        self.direction = direction
        self.edges = edges
    }
}
