//
//  File.swift
//  
//
//  Created by Osama Rabie on 09/09/2023.
//

import Foundation

//MARK: - Extensions
internal extension String {
    
    /// generates a string back from base64 encoding
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
    
    /// generates a base 64 encoding for the string
    func toBase64() -> String? {
        let stringData = data(using: .utf8)!
        let base64EncodedString = stringData.base64EncodedString()
        
        let base64EncodedData = base64EncodedString.data(using: .utf8)!
        
        if let data = Data(base64Encoded: base64EncodedData) {
            return (String(data: data, encoding: .utf8))
        }
        return nil
    }
}


public extension Encodable {
        var tapDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
