//
//  File.swift
//  
//
//  Created by Osama Rabie on 09/09/2023.
//

import Foundation

//MARK: - WebView url methods

/// Computes the components of a certain url
/// - Parameter urlString: The url you want to get teh components from
/// - Returns: The components related to the given url and nil if any issues happened
public func tap_getURLComonents(_ urlString: String?) -> NSURLComponents? {
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

public func tap_getQueryItems(_ urlString: String) -> [String : String] {
    var queryItems: [String : String] = [:]
    let components: NSURLComponents? = tap_getURLComonents(urlString)
    for item in components?.queryItems ?? [] {
        queryItems[item.name] = item.value?.removingPercentEncoding
    }
    return queryItems
}

/// Computes the value of a query parameter
/// - Parameter url: The url you want to get teh components from
/// - Returns: The components related to the given url and nil if any issues happened
public func tap_extractDataFromUrl(_ url: URL,for key:String = "data", shouldBase64Decode:Bool = true) -> String {
    // let us make sure we have a query key with the given key
    if let stringData = tap_getQueryItems(url.absoluteString)[key],
       let stringValue = shouldBase64Decode ? stringData.fromBase64() : stringData {
        return stringValue
    } else {
        return ""
    }
}
