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
    
    /// The selected locale
    var selectedLocale:String = "en" {
        didSet{
            TapLocalisationManager.shared.localisationLocale = selectedLocale
        }
    }
    
    /// The saved customer object
    var savedCustomer:TapCustomer? {
        if let data = UserDefaults.standard.value(forKey:"customerSevedKey") as? Data {
            do {
                return try PropertyListDecoder().decode(TapCustomer.self, from: data)
            } catch {
                print("error paymentTypes: \(error.localizedDescription)")
            }
        }
        return try! .init(identifier: "cus_TS075220212320q2RD0707283")
    }
    
    /// The displayable title for the customer in action
    var customerDisplay:String {
        guard let customerName = savedCustomer?.firstName else {
            return savedCustomer?.identifier ?? ""
        }
        
        return customerName
    }
    
    /// Tells if we need to collect the card holder name or not
    var collectCardHolderName:Bool = false
    
    /// Tells if we need to log UI events
    var logUI:Bool = false
    
    /// Tells if we need to log in console
    var logConsole:Bool = true
    
    /// Tells if we need to log user event
    var logEvents:Bool = true
    
    /// Tells if we need to log api calls
    var logAPI:Bool = true
    
    /// Tells if we need to preload the card name field
    var cardName:String = ""
    
    /// Tells if the user can edit the card name field
    var editCardHolderName:Bool = true
    
    
    /// Tells if the scanner bg should be blurred
    var blurScanner:Bool = true
    
    /// Tells if the scanner borders colors
    var scannerColor:UIColor {
        return scannerColorEnum.toColor()
    }
    
    /// Tells if the scanner borders colors
    var scannerColorEnum:ScannerBlurColor = .Green
    
    
    /// Tells if we need to show the card brand or not
    var showCardBrands:Bool = true
    
    /// Tells if we need to show the loading state in the card view or not
    var showLoadingState:Bool = true
    
    /// Tells if we need to show the card scanning or not
    var showCardScanning:Bool = true
    
    /// Tells if we need to use the online custom theme
    var customTheme:Bool = false
    
    /// Tells what type of cards should be allowed
    var allowedCardTypes:cardTypes = .All
    
    /// deines whether to show the detected brand icon besides the card number instead of the placeholdder
    var showBrandIcon:Bool = true
    
    /// The  animation when showing the 3ds web page
    var animationDuration:TimeInterval = 0.5
    
    /// deines whether to show the heaer above the 3ds web view
    var showWebViewHeader:Bool = true
    
    /// The animation used to show the 3ds web page
    var animationType:ThreeDsWebViewAnimationEnum = .BottomTransition
    
    /// The blur bg of the three ds page
    var threeDSBlurStyle:ThreeDSBlurStyle = .Dark
    
    /// Indicates whether or not the user can edit the card holder name field. Default is true
    var floatingSavedCard:Bool = false
    
    /// Whether to force LTR in arabic for card form
    var forceLTR:Bool = false
    
    func loggingCapabilities() -> [TapLoggingType] {
        
        var allowedLogging:[TapLoggingType] = []
        if logUI {
            allowedLogging.append(.UI)
        }
        if logAPI {
            allowedLogging.append(.API)
        }
        if logEvents {
            allowedLogging.append(.EVENTS)
        }
        if logConsole {
            allowedLogging.append(.CONSOLE)
        }
        
        return allowedLogging
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
