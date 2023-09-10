//
//  utils.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 08/09/2023.
//

import Foundation

//MARK: - Generate tap card sdk url methods

///  Generates a card sdk url with correctly encoded values
///  - Parameter from configurations: the Dictionaty configurations to be url encoded
internal func generateTapCardSdkURL(from configuration: [String : Any]) throws -> String {
    do {
        // Make sure we have a valid string:any dictionaty
        let data = try JSONSerialization.data(withJSONObject: configuration, options: .prettyPrinted)
        let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
        // ul encode the generated string
        let urlEncodedJson = jsonString!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let urlString = "\(TapCardView.tapCardBaseUrl)\(urlEncodedJson!)"
        return urlString
    }
    catch {
        throw error
    }
}

///  Generates a card sdk url with correctly encoded values
///  - Parameter from configurations: the configurations to be url encoded
internal func generateTapCardSdkURL(from configuration: TapCardConfiguration) throws -> String {
    do {
        // ul encode the generated string
        return try generateTapCardSdkURL(from: configuration.dictionary ?? [:])
    }catch {
        throw error
    }
}

///  Generates a card sdk url with correctly encoded values
///  - Parameter from configurations: the String configurations to be url encoded
internal func generateTapCardSdkURL(from configuration: String) -> String {
    let urlEncodedJson = configuration.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    // ul encode the generated string
    return "\(TapCardView.tapCardBaseUrl)\(urlEncodedJson!)"
}


internal extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
