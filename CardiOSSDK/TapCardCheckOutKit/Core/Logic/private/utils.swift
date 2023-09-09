//
//  utils.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 08/09/2023.
//

import Foundation

//MARK: - WebView url methods

/// Computes the components of a certain url
/// - Parameter urlString: The url you want to get teh components from
/// - Returns: The components related to the given url and nil if any issues happened
internal func getURLComonents(_ urlString: String?) -> NSURLComponents? {
    var components: NSURLComponents? = nil
    let linkUrl = URL(string: urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
    if let linkUrl = linkUrl {
        components = NSURLComponents(url: linkUrl, resolvingAgainstBaseURL: true)
    }
    return components
}

/// Computes the query parameters passed as get
/// - Parameter urlString: The url you want to get thh components from
/// - Returns: The dict of the query in [key:value]

internal func getQueryItems(_ urlString: String) -> [String : String] {
    var queryItems: [String : String] = [:]
    let components: NSURLComponents? = getURLComonents(urlString)
    for item in components?.queryItems ?? [] {
        queryItems[item.name] = item.value?.removingPercentEncoding
    }
    return queryItems
}

/// Computes the value of a query parameter
/// - Parameter url: The url you want to get teh components from
/// - Returns: The components related to the given url and nil if any issues happened
internal func extractDataFromUrl(_ url: URL,for key:String = "data", shouldBase64Decode:Bool = true) -> String {
    // let us make sure we have a query key with the given key
    if let stringData = getQueryItems(url.absoluteString)[key],
       let stringValue = shouldBase64Decode ? stringData.fromBase64() : stringData {
        return stringValue
    } else {
        return ""
    }
}


//MARK: - Generate tap card sdk url methods

internal func generateTapCardSdkURL(from configuration: [String : Any]) throws -> String {
    do {
        let data = try JSONSerialization.data(withJSONObject: configuration, options: .prettyPrinted)
        let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
        let urlEncodedJson = jsonString!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let urlString = "\(TapCardView.tapCardBaseUrl)\(urlEncodedJson!)"
        return urlString
    }
    catch {
        throw error
    }
}

internal func generateTapCardSdkURL(from configuration: TapCardConfiguration) throws -> String {
    do {
        return try generateTapCardSdkURL(from: configuration.dictionary ?? [:])
    }catch {
        throw error
    }
}

internal func generateTapCardSdkURL(from configuration: String) -> String {
    let urlEncodedJson = configuration.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    return "\(TapCardView.tapCardBaseUrl)\(urlEncodedJson!)"
}

//MARK: - Extensions
internal extension String {
    func fromBase64() -> String? {
        guard let base64EncodedData = self.data(using: .ascii) else {
            return nil
        }
        if let base64Decoded = Data(base64Encoded: base64EncodedData, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
            return base64Decoded
        }
        return nil
    }
    
    var boolValue: Bool? {
        guard let startIndex = self.firstIndex(where: { !$0.isWhitespace }) else {
            return nil
        }
        
        let endIndex = self.lastIndex(where: { !$0.isWhitespace }) ?? self.endIndex
        let trimmed = self[startIndex...endIndex]
        switch trimmed.lowercased() {
        case "true","yes": return true
        case "false","no": return false
        default: return nil
        }
    }
}



internal extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
