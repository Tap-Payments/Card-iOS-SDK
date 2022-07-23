//
//  ConfigurationSharedManager.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 18/07/2022.
//

/// Singleton shared access to the  demo configuration
let sharedConfigurationSharedManager = ConfigurationSharedManager()

/// Responsible for accessing the  users module on Firebase
class ConfigurationSharedManager {
    
    /// The selected locale
    var selectedLocale:String = "en"
    
    /// Tells if we need to collect the card holder name or not
    var collectCardHolderName:Bool = false
    
    /// Tells if we need to show the card brand or not
    var showCardBrands:Bool = false
    
    /// Tells if we need to show the card scanning or not
    var showCardScanning:Bool = false
    
}
