//
//  TapCardDataConfiguration.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation
import CommonDataModelsKit_iOS


/// The datasource configiation required so the card kit can perform Init call api
@objc public class TapCardDataConfiguration: NSObject {
    
    /**
     The datasource configiation required so the card kit can perform Init call api
     - Parameter sdkMode: Represents the mode of the sdk . Whether sandbox or production
     - Parameter localeIdentifier : The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
     - Parameter secretKey: The secret keys providede to your business from TAP.
     */
    public init(sdkMode: SDKMode = .sandbox, localeIdentifier: String = "en", secretKey: SecretKey = .init(sandbox: "", production: "")) {
        self.sdkMode = sdkMode
        self.localeIdentifier = localeIdentifier
        self.secretKey = secretKey
    }
    
    
    // MARK: Public shared values
    /// Represents the mode of the sdk . Whether sandbox or production
    public var sdkMode:SDKMode = .sandbox
    /// The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
    public var localeIdentifier:String = "en"
    /// The secret keys providede to your business from TAP.
    public var secretKey:SecretKey = .init(sandbox: "", production: "")
    
    
    // MARK: - Private shared values
    
    /// The currency you want to show the card brands that accepts it. Default is KWD
    internal var transactionCurrency: TapCurrencyCode = .KWD
    /// The attached customer passed for this transaction (e.g. save card)
    internal var transactionCustomer: TapCustomer?
    /// Metdata object will be a representation of [String:String] dictionary to be used whenever such a common model needed
    internal var metadata:TapMetadata? = nil
    /// Holding the latest init response model to fetch requierd data when needed like session token or encryption key
    internal var sdkSettings:SDKSettings?
    /// Holding the allowed card brands to process for the logged in merchant
    internal var paymentOptions:[PaymentOption]?
    
    /// Holding the latest Config response from the middleware
    internal var configModelResponse: TapConfigResponseModel?
    
    /// Holding the latest look up response from the middleware
    internal var tapBinLookUpResponse: TapBinResponseModel?
    
    /// Holding the latest card verify response from the middleware
    internal var cardVerify: TapCreateCardVerificationResponseModel?
}
