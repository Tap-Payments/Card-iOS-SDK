//
//  ConfigurationSharedManager.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 18/07/2022.
//

import CommonDataModelsKit_iOS
import LocalisationManagerKit_iOS

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
    
    /// Tells if we need to collect the card holder name or not
    var collectCardHolderName:Bool = false
    
    /// Tells if we need to preload the card name field
    var cardName:String = "None"
    
    /// Tells if the user can edit the card name field
    var editCardHolderName:Bool = true
    
    /// Tells if we need to show the card brand or not
    var showCardBrands:Bool = false
    
    /// Tells if we need to show the card scanning or not
    var showCardScanning:Bool = false
    
    /// Tells what type of cards should be allowed
    var allowedCardTypes:cardTypes = .All
    
}
