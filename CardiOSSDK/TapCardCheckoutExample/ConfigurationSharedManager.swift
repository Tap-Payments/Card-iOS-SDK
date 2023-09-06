//
//  ConfigurationSharedManager.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 18/07/2022.
//

import CommonDataModelsKit_iOS
import LocalisationManagerKit_iOS
import UIKit
import TapCardCheckOutKit

/// Singleton shared access to the  demo configuration
let sharedConfigurationSharedManager = ConfigurationSharedManager()

/// Responsible for accessing the  users module on Firebase
class ConfigurationSharedManager {
    /// The public keys providede to your business from Tap integration team.
    var publicKey:SecretKey = .init(sandbox: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp")
    /// An enum to define the required scope of the tap card sdk. Default is to generate Tap Token for the card
    var  scope: Scope = .TapToken
    /// A model that represents the amount and the currency combined. Default is 1 KWD
    var transcation: Transaction = .init()
    /// A model that represents the details and configurations related to the merchant. Including your merchant id provided by Tap integration team
    var merchant: TapCardCheckOutKit.Merchant = .init()
    /// Represents the model for the customer if any.
    var customer: TapCustomer = TapCustomer.defaultCustomer()
    /// A  model that represents the reference to Tap order if needed
    internal var order: Order? = nil
    /// A model that decides the enablement of some of teh Tap provided features related to UI/UX
    internal var features: Features = .init()
    /// A model that represents the details of the acceptance levels and payment methods. Like, payment methods, payment brands, types of allowed cards etc. Default is to accept all allowed payment methods activiated to your business from Tap integration team.
    var acceptance: Acceptance = .init()
    /// Defines which card fields you want to show/hide. Currently, only card name is controllable and default is true.
    var fields: Fields = .init()
    /// A model that decides the visibilty of some componens related to the card sdk. So the merchant can adjust the UX as much as possible to fit his UI
    var addons: Addons = .init()
    /// A model of parameters that controls a bit the look and feel of the card sdk.
    var interface: Interface = .init()
    
    func customerDisplay() -> String {
        if let customerID = customer.identifier,
           customerID != "" {
            return customerID
        }
        
        return customer.firstName ?? "No customer identified"
    }
}


enum ScannerBlurColor: CaseIterable {
    case Green
    case White
    case Red
    
    func toColor() -> UIColor {
        switch self {
            
        case .Green:
            return .green
        case .White:
            return .white
        case .Red:
            return .red
        }
    }
    
    func toString() -> String {
        switch self {
        case .Green:
            return "Green"
        case .White:
            return "White"
        case .Red:
            return "Red"
        }
    }
}


/*
enum ThreeDSBlurStyle: CaseIterable {
    case Light
    case ExtraLight
    case Dark
    case Prominent
    case Regular
    
    func toBlurStyle() -> UIBlurEffect.Style {
        switch self {
            
        case .Light:
            return .light
        case .ExtraLight:
            return .extraLight
        case .Prominent:
            return .prominent
        case .Regular:
            return .regular
        case .Dark:
            return .dark
        }
    }
    
    func toString() -> String {
        switch self {
            
        case .Light:
            return "Light"
        case .ExtraLight:
            return "ExtraLight"
        case .Dark:
            return "Dark"
        case .Prominent:
            return "Prominent"
        case .Regular:
            return "Regular"
        }
    }
}
*/
