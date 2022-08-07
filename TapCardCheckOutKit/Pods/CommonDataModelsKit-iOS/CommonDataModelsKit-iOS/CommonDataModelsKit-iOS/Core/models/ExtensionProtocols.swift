//
//  OptionallyIdentifiableWithString.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 11/15/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/// All models that have identifier are conforming to this protocol.
public protocol OptionallyIdentifiableWithString {
    
    // MARK: Properties
    
    /// Unique identifier of an object.
    var identifier: String? { get }
}


/// A protocol used to imply that the sub class has an array of supported currencies and can be filtered regarding it
public protocol FilterableByCurrency {
    
    var supportedCurrencies: [TapCurrencyCode] { get }
}

/// A protocol used to imply that the sub class has an array can be sorted by a given KEY
public protocol SortableByOrder {
    
    var orderBy: Int { get }
}
