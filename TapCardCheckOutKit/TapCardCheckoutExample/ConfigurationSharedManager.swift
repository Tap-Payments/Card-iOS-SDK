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
    
}
