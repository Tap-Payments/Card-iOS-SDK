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
        self.secretKey = secretKey
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
    internal var secretKey:SecretKey = .init(sandbox: "", production: "")
    
    /// The currency you want to show the card brands that accepts it. Default is KWD
    internal var transactionCurrency: TapCurrencyCode = .KWD
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
