//
//  PaymentOption.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/15/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
import struct PassKit.PKPaymentNetwork
import CommonDataModelsKit_iOS
import TapCardVlidatorKit_iOS
import class TapUIKit_iOS.TapCardPhoneIconViewModel

/// Payment Option model.
internal struct PaymentOption: IdentifiableWithString {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Unique identifier for the object.
    internal let identifier: String
    
    /// Payment option card brand.
    internal let brand: CardBrand
    
    /// Name of the payment option.
    internal var title: String
    
    /// Image URL of the payment option.
    internal let backendImageURL: URL
    
    /// If the payment option is async or not
    internal let isAsync: Bool
    
    /// Payment type.
    internal var paymentType: TapPaymentType
    
    /// Source identifier.
    internal private(set) var sourceIdentifier: String?
    
    /// Supported card brands.
    internal let supportedCardBrands: [CardBrand]
    
    
    /// List of supported currencies.
    internal let supportedCurrencies: [TapCurrencyCode]
    
    /// Ordering parameter.
    internal let orderBy: Int
    
    /// Decide if the 3ds should be disabled, enabled or set by user for this payment option
    internal let threeDLevel: ThreeDSecurityState
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier             = "id"
        case title                  = "name"
        case backendImageURL        = "image"
        case paymentType            = "payment_type"
        case sourceIdentifier       = "source_id"
        case supportedCardBrands    = "supported_card_brands"
        case supportedCurrencies    = "supported_currencies"
        case orderBy                = "order_by"
        case isAsync                = "asynchronous"
        case threeDLevel            = "threeDS"
    }
    
    private static func mapThreeDLevel(with threeD:String) -> ThreeDSecurityState
    {
        if threeD.lowercased() == "n"
        {
            return .never
        }else if threeD.lowercased() == "y"
        {
            return .always
        }else
        {
            return .definedByMerchant
        }
    }
}

// MARK: - Decodable
extension PaymentOption: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container           = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier          = try container.decode          (String.self,               forKey: .identifier)
        let brand               = try container.decode          (CardBrand.self,            forKey: .title)
        let title               = try container.decode          (String.self,               forKey: .title)
        let imageURL            = try container.decode          (URL.self,                  forKey: .backendImageURL)
        let paymentType         = try container.decode          (TapPaymentType.self,       forKey: .paymentType)
        let sourceIdentifier    = try container.decodeIfPresent (String.self,               forKey: .sourceIdentifier)
        var supportedCardBrands = try container.decode          ([CardBrand].self,          forKey: .supportedCardBrands)
        let supportedCurrencies = try container.decode          ([TapCurrencyCode].self,    forKey: .supportedCurrencies)
        let orderBy             = try container.decode          (Int.self,                  forKey: .orderBy)
        let isAsync             = try container.decode          (Bool.self,                 forKey: .isAsync)
        let threeDLevel         = try container.decodeIfPresent (String.self,               forKey: .threeDLevel) ?? "U"
        
        supportedCardBrands = supportedCardBrands.filter { $0 != .unknown }
        
        self.init(identifier: identifier,
                  brand: brand,
                  title: title,
                  backendImageURL: imageURL,
                  isAsync: isAsync, paymentType: paymentType,
                  sourceIdentifier: sourceIdentifier,
                  supportedCardBrands: supportedCardBrands,
                  supportedCurrencies: supportedCurrencies,
                  orderBy: orderBy,
                  threeDLevel: PaymentOption.mapThreeDLevel(with: threeDLevel))
    }
}

extension PaymentOption
{
    internal enum ThreeDSecurityState {
        
        case always
        case never
        case definedByMerchant
    }
}

// MARK: - FilterableByCurrency
extension PaymentOption: FilterableByCurrency {}

// MARK: - SortableByOrder
extension PaymentOption: SortableByOrder {}

// MARK: - Equatable
extension PaymentOption: Equatable {
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `false` otherwise.
    public static func == (lhs: PaymentOption, rhs: PaymentOption) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}



/// A protocol used to imply that the sub class has an array of supported currencies and can be filtered regarding it
internal protocol FilterableByCurrency {
    
    var supportedCurrencies: [TapCurrencyCode] { get }
}

/// A protocol used to imply that the sub class has an array can be sorted by a given KEY
internal protocol SortableByOrder {
    
    var orderBy: Int { get }
}

/// All models that have identifier are conforming to this protocol.
internal protocol OptionallyIdentifiableWithString {
    
    // MARK: Properties
    
    /// Unique identifier of an object.
    var identifier: String? { get }
}


extension Array where Element == PaymentOption {
    
    /// Converts a list of card payment options to understandable format class datasrouce for the card brands list
    /// - Parameter supportsCurrency: Pass this optional if you want to filter out cards that support a certain currency
    func toTapCardPhoneIconViewModel(supportsCurrency:TapCurrencyCode = .ALL) -> [TapCardPhoneIconViewModel] {
        return self.filter{ supportsCurrency == .ALL || $0.supportedCurrencies.contains(supportsCurrency) }
            .map{ .init(associatedCardBrand: $0.brand , tapCardPhoneIconUrl: $0.backendImageURL.absoluteString) }
    }
    
}
