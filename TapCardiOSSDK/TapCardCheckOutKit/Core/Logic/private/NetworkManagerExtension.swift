//
//  NetworkManagerExtension.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation
import CoreTelephony
import TapApplicationV2
import LocalisationManagerKit_iOS
import CommonDataModelsKit_iOS

/// Extension to the network manager when needed. To keep the network manager class itself clean and readable
internal extension NetworkManager {
    
    
    /// Static HTTP headers sent with each request. including device info, language and SDK secret keys
    static var staticHTTPHeaders: [String: String] {
        
        let secretKey = NetworkManager.secretKey()
        
        guard secretKey.tap_length > 0 else {
            
            fatalError("Secret key must be set in order to use goSellSDK.")
        }
        
        let applicationValue = applicationHeaderValue
        
        var result = [
            
            Constants.HTTPHeaderKey.authorization: "Bearer \(secretKey)",
            Constants.HTTPHeaderKey.application: applicationValue,
            Constants.HTTPHeaderKey.contentTypeHeaderName: Constants.HTTPHeaderValueKey.jsonContentTypeHeaderValue
        ]
        
        if let sessionToken = sharedNetworkManager.dataConfig.sdkSettings?.sessionToken, !sessionToken.isEmpty {
            
            result[Constants.HTTPHeaderKey.sessionToken] = sessionToken
        }
        
        if let middleWareToken = sharedNetworkManager.dataConfig.configModelResponse?.token {
            
            result[Constants.HTTPHeaderKey.token] = "Bearer \(middleWareToken)"
        }
        
        return result
    }
    
    /// HTTP headers that contains the device and app info
    static var applicationHeaderValue: String {
        
        var applicationDetails = NetworkManager.applicationStaticDetails()
        
        if let deviceID = KeychainManager.deviceID {
            
            applicationDetails[Constants.HTTPHeaderValueKey.deviceID] = deviceID
        }
        
        let result = (applicationDetails.map { "\($0.key)=\($0.value)" }).joined(separator: "|")
        
        return result
    }
    
    /**
     Used to fetch the correct secret key based on the selected SDK mode
     - Returns: The sandbox or production secret key based on the SDK mode
     */
    static func secretKey() -> String {
        return (sharedNetworkManager.dataConfig.sdkMode == .sandbox) ?  sharedNetworkManager.dataConfig.secretKey.sandbox : sharedNetworkManager.dataConfig.secretKey.production
    }
    
    
    /// A computed variable that generates at access time the required static headers by the server.
    static private func applicationStaticDetails() -> [String: String] {
        
        /*guard let bundleID = TapApplicationPlistInfo.shared.bundleIdentifier, !bundleID.isEmpty else {
         
         fatalError("Application must have bundle identifier in order to use goSellSDK.")
         }*/
        
        let headersEncryptionKey:String = """
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8AX++RtxPZFtns4XzXFlDIxPB
h0umN4qRXZaKDIlb6a3MknaB7psJWmf2l+e4Cfh9b5tey/+rZqpQ065eXTZfGCAu
BLt+fYLQBhLfjRpk8S6hlIzc1Kdjg65uqzMwcTd0p7I4KLwHk1I0oXzuEu53fU1L
SZhWp4Mnd6wjVgXAsQIDAQAB
-----END PUBLIC KEY-----
"""
        
        let bundleID = "tap.TapCardCheckoutExample"
        
        let sdkPlistInfo = TapBundlePlistInfo(bundle: Bundle(for: NetworkManager.self))
        let mainAppBundle = TapBundlePlistInfo(bundle: .main)
        
        let localeIdentifier = TapLocalisationManager.shared.localisationLocale ?? "en"
        
        
        let appVersion = mainAppBundle.shortVersionString ?? ""
        let appName = mainAppBundle.bundleName ?? ""
        
        guard let requirerVersion = sdkPlistInfo.shortVersionString, !requirerVersion.isEmpty else {
            
            fatalError("Seems like SDK is not integrated well.")
        }
        let networkInfo = CTTelephonyNetworkInfo()
        let providers = networkInfo.serviceSubscriberCellularProviders
        
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let deviceName = UIDevice.current.name
        let deviceNameFiltered =  deviceName.tap_byRemovingAllCharactersExcept("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789")
        let deviceType = UIDevice.current.model
        let deviceModel = UIDevice.current.localizedModel
        var simNetWorkName:String? = ""
        var simCountryISO:String? = ""
        
        if providers?.values.count ?? 0 > 0 {
            providers?.values.forEach { carrier in
                if let carrierName = carrier.carrierName {
                    simNetWorkName = carrierName
                }
                if let isoCountryCode = carrier.isoCountryCode {
                    simCountryISO = isoCountryCode
                }
            }
        }
        
        
        let result: [String: String] = [
            Constants.HTTPHeaderValueKey.appID: Crypter.encrypt(bundleID, using: headersEncryptionKey) ?? bundleID,
            Constants.HTTPHeaderValueKey.appLocale: Crypter.encrypt(localeIdentifier, using: headersEncryptionKey) ?? localeIdentifier,
            Constants.HTTPHeaderValueKey.appName: Crypter.encrypt(appName, using: headersEncryptionKey) ?? appName,
            Constants.HTTPHeaderValueKey.appVersion: Crypter.encrypt(appVersion, using: headersEncryptionKey) ?? appVersion,
            Constants.HTTPHeaderValueKey.requirer: Constants.HTTPHeaderValueKey.requirerValue,
            Constants.HTTPHeaderValueKey.requirerVersion: requirerVersion,
            Constants.HTTPHeaderValueKey.requirerOS: Crypter.encrypt(osName, using: headersEncryptionKey) ?? osName,
            Constants.HTTPHeaderValueKey.requirerOSVersion: Crypter.encrypt(osVersion, using: headersEncryptionKey) ?? osVersion,
            Constants.HTTPHeaderValueKey.requirerDeviceName: Crypter.encrypt(deviceNameFiltered, using: headersEncryptionKey) ?? deviceNameFiltered,
            Constants.HTTPHeaderValueKey.requirerDeviceType: Crypter.encrypt(deviceType, using: headersEncryptionKey) ?? deviceType,
            Constants.HTTPHeaderValueKey.requirerDeviceModel: Crypter.encrypt(deviceModel, using: headersEncryptionKey) ?? deviceModel,
            Constants.HTTPHeaderValueKey.requirerSimNetworkName: simNetWorkName ?? "",
            Constants.HTTPHeaderValueKey.requirerSimCountryIso: simCountryISO ?? "",
            Constants.HTTPHeaderValueKey.requirerDeviceManufacturer: Crypter.encrypt("Apple", using: headersEncryptionKey) ?? "Apple",
        ]
        
        return result
    }
    
    
    
    struct Constants {
        
        internal static let authenticateParameter = "authenticate"
        
        fileprivate static let timeoutInterval: TimeInterval            = 60.0
        fileprivate static let cachePolicy:     URLRequest.CachePolicy  = .reloadIgnoringCacheData
        
        fileprivate static let successStatusCodes = 200...299
        
        fileprivate struct HTTPHeaderKey {
            
            fileprivate static let authorization    = "Authorization"
            fileprivate static let application      = "application"
            fileprivate static let sessionToken     = "session_token"
            fileprivate static let contentTypeHeaderName        = "Content-Type"
            fileprivate static let token                = "token"
            
            //@available(*, unavailable) private init() { }
        }
        
        fileprivate struct HTTPHeaderValueKey {
            
            fileprivate static let appID                        = "aid"
            fileprivate static let appLocale                    = "al"
            fileprivate static let appVersion                   = "av"
            fileprivate static let appName                      = "an"
            fileprivate static let deviceID                     = "device_id"
            fileprivate static let requirer                     = "requirer"
            fileprivate static let requirerOS                   = "ro"
            fileprivate static let requirerOSVersion            = "rov"
            fileprivate static let requirerValue                = "SDK"
            fileprivate static let requirerVersion              = "requirer_version"
            fileprivate static let requirerDeviceName           = "rn"
            fileprivate static let requirerDeviceType           = "rt"
            fileprivate static let requirerDeviceModel          = "rm"
            fileprivate static let requirerSimNetworkName       = "requirer_sim_network_name"
            fileprivate static let requirerSimCountryIso        = "requirer_sim_country_iso"
            fileprivate static let jsonContentTypeHeaderValue   = "application/json"
            fileprivate static let requirerDeviceManufacturer   = "rb"
            
            //@available(*, unavailable) private init() { }
        }
    }
}
