//
//  CardKitErrorType.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 24/07/2022.
//

import Foundation


/// Enum defining SDK mode.
@objc public enum CardKitErrorType: Int, CaseIterable {
    
    @objc(Network)          case Network
    @objc(InvalidCardType)  case InvalidCardType
}

// MARK: - CustomStringConvertible
extension CardKitErrorType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .Network:          return "Network error occured"
        case .InvalidCardType:  return "The user entered a card not matching the given allowed type"
        }
    }
}

