//
//  TapCard+Plist.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 13/09/2023.
//

import Foundation
import UIKit

/// Dummy class to get application plist information.
 public class TapApplicationPlistInfo {
    
    // MARK: -  -
    // MARK: Properties
    
     public static let shared = TapApplicationPlistInfo()
    
    // MARK: Methods
    
    /// Returns `true` if application's `Info.plist` file contains usage description for the given `permission`, `false` otherwise.
    ///
    /// - Parameter permission: System permission.
    /// - Returns: `true` if application's `Info.plist` file contains usage description for the given `permission`, `false` otherwise.
     func hasUsageDescription(for permission: TapSystemPermission) -> Bool {
        
        return self.usageDescriptions(for: permission) != nil
    }
    
    /// Returns list of usage descriptions taken from the application's `Info.plist` file or `nil` if there are no descriptions for the given `permission`.
    ///
    /// - Parameter permission: System permission.
    /// - Returns:  List of usage descriptions taken from the application's `Info.plist` file or `nil` if there are no descriptions for the given `permission`.
     func usageDescriptions(for permission: TapSystemPermission) -> [String]? {
        
        let keys = permission.plistKeys
        
        let result: [String] = keys.compactMap { if let text: String = self.plistObject(for: $0), text.tap_length > 0 { return text } else { return nil } }
        
        if result.count > 0 {
            
            return result
            
        } else {
            
            return nil
        }
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private init() {}
}

// MARK: - TapApplicationWithPlist
extension TapApplicationPlistInfo: TapApplicationWithPlist {
    
     public var bundle: Bundle {
        
        return .main
    }
}



/// System permissions enum
///
/// - appleMusic: Apple Music
/// - bluetooth: Bluetooth
/// - calendar: Calendar
/// - camera: Camera
/// - contacts: Contacts
/// - health: Health
/// - home: Home
/// - location: Location
/// - microphone: Microphone
/// - motion: Motion
/// - photos: Photos
/// - reminders: Reminders
/// - siri: Siri
/// - speechRecognition: Speech recognition
/// - tvProviderAccount: TP Provider Account
public enum TapSystemPermission {
    
    case appleMusic
    case bluetooth
    case calendar
    case camera
    case contacts
    case health(TapHealthPermission)
    case home
    case location(TapLocationPermission)
    case microphone
    case motion
    case photos
    case reminders
    case siri
    case speechRecognition
    case tvProviderAccount
    
    // MARK: - Internal -
    
    internal var plistKeys: [String] {
        
        switch self {
            
        case .appleMusic:               return [PlistKey.appleMusic]
        case .bluetooth:                return [PlistKey.bluetooth]
        case .calendar:                 return [PlistKey.calendar]
        case .camera:                   return [PlistKey.camera]
        case .contacts:                 return [PlistKey.contacts]
        case .health(let context):      return context.plistKeys
        case .home:                     return [PlistKey.home]
        case .location(let context):    return context.plistKeys
        case .microphone:               return [PlistKey.microphone]
        case .motion:                   return [PlistKey.motion]
        case .photos:                   return [PlistKey.photos]
        case .reminders:                return [PlistKey.reminders]
        case .siri:                     return [PlistKey.siri]
        case .speechRecognition:        return [PlistKey.speechRecognition]
        case .tvProviderAccount:        return [PlistKey.tvProviderAccount]
        }
    }
    
    // MARK: - Private -
    
    private struct PlistKey {
        
        fileprivate static let appleMusic           = "NSAppleMusicUsageDescription"
        fileprivate static let bluetooth            = "NSBluetoothPeripheralUsageDescription"
        fileprivate static let calendar             = "NSCalendarsUsageDescription"
        fileprivate static let camera               = "NSCameraUsageDescription"
        fileprivate static let contacts             = "NSContactsUsageDescription"
        fileprivate static let home                 = "NSHomeKitUsageDescription"
        fileprivate static let microphone           = "NSMicrophoneUsageDescription"
        fileprivate static let motion               = "NSMotionUsageDescription"
        fileprivate static let photos               = "NSPhotoLibraryUsageDescription"
        fileprivate static let reminders            = "NSRemindersUsageDescription"
        fileprivate static let siri                 = "NSSiriUsageDescription"
        fileprivate static let speechRecognition    = "NSSpeechRecognitionUsageDescription"
        fileprivate static let tvProviderAccount    = "NSVideoSubscriberAccountUsageDescription"
        
        //@available(*, unavailable) private init() {}
    }
}

/// TapHealPermission
///
/// - share: Permission to share health data.
/// - update: Permission to update health data.
public enum TapHealthPermission {
    
    case share
    case update
    
    // MARK: - Fileprivate -
    // MARK: Properties
    
    fileprivate var plistKeys: [String] {
        
        switch self {
            
        case .share:    return [PlistKey.share]
        case .update:   return [PlistKey.update]
            
        }
    }
    
    // MARK: - Private -
    
    private struct PlistKey {
        
        fileprivate static let share    = "NSHealthShareUsageDescription"
        fileprivate static let update   = "NSHealthUpdateUsageDescription"
        
        //@available(*, unavailable) private init() {}
    }
}

// MARK: - TapLocationPermission -

/// TapLocationPermission
///
/// - any: At least any permission.
/// - whenInUse: Permission to use location when app is in foreground.
/// - always: Permission to use location always.
public enum TapLocationPermission {
    
    case any
    case whenInUse
    case always
    
    // MARK: - Fileprivate -
    // MARK: Properties
    
    fileprivate var plistKeys: [String] {
        
        switch self {
            
        case .any:          return [PlistKey.whenInUse, PlistKey.always]
        case .whenInUse:    return [PlistKey.whenInUse]
        case .always:       return [PlistKey.always]
            
        }
    }
    
    // MARK: - Private -
    
    private struct PlistKey {
        
        fileprivate static let whenInUse    = "NSLocationWhenInUseUsageDescription"
        fileprivate static let always       = "NSLocationAlwaysUsageDescription"
        
        //@available(*, unavailable) private init() {}
    }
}


/// Protocol to retrieve most of the plist information from bundle.
public protocol TapBundleWithPlist {
    
    // MARK: Properties
    
    /// Bundle to retrieve information from.
    var bundle: Bundle { get }
}

public extension TapBundleWithPlist {
    
    // MARK: - Public -
    // MARK: Properties
    
    var buildMachineOSBuild: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.buildMachineOSBuild)
    }
    
    var bundleDevelopmentRegion: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundleDevelopmentRegion)
    }
    
    var bundleExecutable: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundleExecutable)
    }
    
    var bundleIdentifier: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundleIdentifier)
    }
    
    var bundleInfoDictionaryVersion: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundleInfoDictionaryVersion)
    }
    
    var bundleName: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundleName)
    }
    
    var bundleNumericVersion: Int64? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundleNumericVersion)
    }
    
    var bundlePackageType: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundlePackageType)
    }
    
    var shortVersionString: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.shortVersionString)
    }
    
    var bundleSignature: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundleSignature)
    }
    
    var supportedPlatforms: [String]? {
        
        return self.plistObject(for: TapBundleInfoKeys.supportedPlatforms)
    }
    
    var bundleVersion: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.bundleVersion)
    }
    
    var compiler: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.compiler)
    }
    
    var platformBuild: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.platformBuild)
    }
    
    var platformName: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.platformName)
    }
    
    var platformVersion: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.platformVersion)
    }
    
    var sdkBuild: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.sdkBuild)
    }
    
    var sdkName: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.sdkName)
    }
    
    var xcodeVersion: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.xcodeVersion)
    }
    
    var xcodeBuild: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.xcodeBuild)
    }
    
    var minimumOSVersion: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.minimumOSVersion)
    }
    
    var deviceFamily: [UIUserInterfaceIdiom]? {
        
        return self.plistObject(for: TapBundleInfoKeys.deviceFamily)
    }
    
    var requiredDeviceCapabilities: String? {
        
        return self.plistObject(for: TapBundleInfoKeys.requiredDeviceCapabilities)
    }
    
    // MARK: Methods
    
    internal func plistObject<ReturnType>(for key: String) -> ReturnType? {
        
        return self.bundle.object(forInfoDictionaryKey: key) as? ReturnType
    }
}


/// Bundle info.plist keys constants.
internal struct TapBundleInfoKeys {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static let buildMachineOSBuild         = "BuildMachineOSBuild"
    internal static let bundleDevelopmentRegion     = "\(kCFBundleDevelopmentRegionKey!)"
    internal static let bundleExecutable            = "\(kCFBundleExecutableKey!)"
    internal static let bundleIdentifier            = "\(kCFBundleIdentifierKey!)"
    internal static let bundleInfoDictionaryVersion = "\(kCFBundleInfoDictionaryVersionKey!)"
    internal static let bundleName                  = "\(kCFBundleNameKey!)"
    internal static let bundleNumericVersion        = "CFBundleNumericVersion"
    internal static let bundlePackageType           = "CFBundlePackageType"
    internal static let shortVersionString          = "CFBundleShortVersionString"
    internal static let bundleSignature             = "CFBundleSignature"
    internal static let supportedPlatforms          = "CFBundleSupportedPlatforms"
    internal static let bundleVersion               = "\(kCFBundleVersionKey!)"
    internal static let compiler                    = "DTCompiler"
    internal static let platformBuild               = "DTPlatformBuild"
    internal static let platformName                = "DTPlatformName"
    internal static let platformVersion             = "DTPlatformVersion"
    internal static let sdkBuild                    = "DTSDKBuild"
    internal static let sdkName                     = "DTSDKName"
    internal static let xcodeVersion                = "DTXcode"
    internal static let xcodeBuild                  = "DTXcodeBuild"
    internal static let minimumOSVersion            = "MinimumOSVersion"
    internal static let deviceFamily                = "UIDeviceFamily"
    internal static let requiredDeviceCapabilities  = "UIRequiredDeviceCapabilities"
    
    internal static let displayName                 = "CFBundleDisplayName"
    
    // MARK: - Private -
    
    /*@available(*, unavailable) private init() {
     
     fatalError("\(self) cannot be instantiated.")
     }*/
}



/// Protocol to retrieve interesting plist info from the main application bundle.
public protocol TapApplicationWithPlist: TapBundleWithPlist {}

public extension TapApplicationWithPlist {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Application display name.
    var displayName: String {
        
        return self.plistObject(for: TapBundleInfoKeys.displayName) ?? .tap_empty
    }
    
    /// Application short version ( e.g. "1.1" )
    var shortVersion: String {
        
        return self.shortVersionString ?? .tap_empty
    }
    
    /// Application build string.
    var build: String {
        
        return self.bundleVersion ?? .tap_empty
    }
    
    /// Deep link URL scheme (if present).
    var deepLinkURLScheme: String? {
        
        guard let urlTypes: [[String: Any]] = self.plistObject(for: InfoPlistKeys.urlTypes) else { return nil }
        
        let bundleID = self.bundleIdentifier
        
        for type in urlTypes {
            
            guard let bundleURLName = type[InfoPlistKeys.URLTypes.urlName] as? String, bundleURLName == bundleID else { continue }
            guard let urlSchemes = type[InfoPlistKeys.URLTypes.urlSchemes] as? [String], urlSchemes.count > 0 else { continue }
            
            guard urlSchemes.filter({ $0.hasPrefix(InfoPlistKeys.URLTypes.tagmanager) }).count == 0 else { continue }
            
            return urlSchemes.first
        }
        
        return nil
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func infoPlistString(for key: String) -> String {
        
        return self.plistObject(for: key) ?? .tap_empty
    }
}

private struct InfoPlistKeys {
    
    fileprivate static let urlTypes = "CFBundleURLTypes"
    
    fileprivate struct URLTypes {
        
        fileprivate static let tagmanager = "tagmanager"
        fileprivate static let urlName = "CFBundleURLName"
        fileprivate static let urlSchemes = "CFBundleURLSchemes"
        
        //@available(*, unavailable) private init() {}
    }
    
    //@available(*, unavailable) private init() {}
}



public class TapBundlePlistInfo {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Bundle.
    public let bundle: Bundle
    
    // MARK: Methods
    
    /// Initializes PlistInfo with the given `bundle`.
    ///
    /// - Parameter bundle: Bundle.
    public required init(bundle: Bundle) {
        
        self.bundle = bundle
    }
}

extension TapBundlePlistInfo: TapBundleWithPlist {}
