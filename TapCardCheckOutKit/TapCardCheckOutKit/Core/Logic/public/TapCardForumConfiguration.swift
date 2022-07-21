//
//  TapCardForumConfiguration.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation
import TapThemeManager2020
import LocalisationManagerKit_iOS
import MOLH
/// The shared configuration needed to set up the tap card forum on boot
@objc public class TapCardForumConfiguration: NSObject {
    
    /// The singletong network manager
    @objc static public let shared = TapCardForumConfiguration()
    
    /// A reference to the localisation manager
    private var sharedLocalisationManager = TapLocalisationManager.shared
    
    /// The data configured by you as a merchant (e.g. secret key, locale, etc.)
    internal var dataConfig:TapCardDataConfiguration? {
        didSet{
            if let nonNullConfig = dataConfig {
                NetworkManager.shared.dataConfig = nonNullConfig
            }
        }
    }
    
    /// The theme object which contains the path to the local or to the remote custom light and dark themes
    internal var customTheme:TapCardForumTheme?{
        didSet{
            configureThemeManager()
        }
    }
    
    /// The localisation object which contains the path to the local or to the remote custom localisation files
    internal var customLocalisation:TapCardForumLocalisation?{
        didSet{
            configureLocalisationManager()
        }
    }
    
    /**
     Populate the card forum configuration with the required data.
     - Parameter dataConfig: The data configured by you as a merchant (e.g. secret key, locale, etc.). Required
     - Parameter cusomTheme: The theme object which contains the path to the local or to the remote custom light and dark themes. Optional
     - Parameter customLocalisation: The localisation object which contains the path to the local or to the remote custom localisation files. Optional
     */
    @objc public func configure(dataConfig: TapCardDataConfiguration, customTheme: TapCardForumTheme? = nil, customLocalisation: TapCardForumLocalisation? = nil) {
        self.dataConfig = dataConfig
        self.customTheme = customTheme
        self.customLocalisation = customLocalisation
        configureSDK()
    }
    
    
    /// Calls the init api and make all the data for card brands and tokenization availbe
    private func configureSDK() {
        guard let nonNullDataConfig = self.dataConfig else { return }
        // Store the configueation data for further access
        NetworkManager.shared.dataConfig = nonNullDataConfig
        // Infotm the network manager to init itself from the init api
        NetworkManager.shared.configSDK()
    }
    
    
    
    /** Configures the theme manager by setting the provided custom theme file names
     - Parameter customTheme: Please pass the tap checkout theme object with the names of your custom theme files if needed. If not set, the normal and default TAP theme will be used
     */
    private func configureThemeManager() {
        guard let nonNullCustomTheme = customTheme else {
            TapThemeManager.setDefaultTapTheme()
            return
        }
        switch nonNullCustomTheme.themeType {
        case .LocalJsonFile: TapThemeManager.setDefaultTapTheme(lightModeJSONTheme: nonNullCustomTheme.lightModeThemeFileName ?? "", darkModeJSONTheme: nonNullCustomTheme.darkModeThemeFileName ?? "")
        case .RemoteJsonFile: TapThemeManager.setDefaultTapTheme(lightModeURLTheme: URL(string:nonNullCustomTheme.lightModeThemeFileName ?? "") ?? nil, darkModeURLTheme: URL(string: nonNullCustomTheme.darkModeThemeFileName ?? "") ?? nil)
        case .none:
            TapThemeManager.setDefaultTapTheme(lightModeJSONTheme: nonNullCustomTheme.lightModeThemeFileName ?? "", darkModeJSONTheme: nonNullCustomTheme.darkModeThemeFileName ?? "")
        }
    }
    
    
    /** Configures the localisation manager bu setting the locale, adjusting the flipping and the localisation custom model if any
     - Parameter localiseFile: Please pass the name of the custom localisation model if needed. If not set, the normal and default TAP localisations will be used
     */
    private func configureLocalisationManager() {
        // Set the required locale
        sharedLocalisationManager.localisationLocale = customLocalisation?.localeIdentifier ?? "en"
        // Adjust the flipping
        if customLocalisation?.shouldFlip ?? false {
            MOLH.setLanguageTo(sharedLocalisationManager.localisationLocale ?? "en")
        }
        
        // Check if the user provided a custom localisation file to use and it is a correct and a reachable one
        // Depends on the type of the localisation whether remote or locale
        guard let nonNullLocalisationModel = customLocalisation,
              let nonNullFilePathURL = nonNullLocalisationModel.filePath,
              let nonNullLocaltionType = nonNullLocalisationModel.localisationType else { return }
        let _ = sharedLocalisationManager.configureLocalisation(with: nonNullFilePathURL, from: nonNullLocaltionType)
    }
}
