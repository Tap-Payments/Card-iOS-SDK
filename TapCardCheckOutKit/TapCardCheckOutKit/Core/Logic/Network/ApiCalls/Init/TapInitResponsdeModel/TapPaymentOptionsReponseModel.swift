//
//  TapPaymentOptionsReponseModel.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/15/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
import CommonDataModelsKit_iOS

/// Payment Options Response model.
internal struct TapPaymentOptionsReponseModel: IdentifiableWithString {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Object identifier.
    internal let identifier: String
    
    /// Order identifier.
    internal private(set) var orderIdentifier: String?
    
    /// Object type.
    internal let object: String
    
    /// List of available payment options.
    internal let paymentOptions: [PaymentOption]
    
    /// Transaction currency.
    internal let currency: TapCurrencyCode
    
    /// Merchant iso country code.
    internal let merchantCountryCode: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case currency                   = "currency"
        case identifier                 = "id"
        case object                     = "object"
        case paymentOptions             = "payment_methods"
        case orderIdentifier            = "order_id"
        case merchantCountryCode        = "country"
    }
    
    // MARK: Methods
    
    private init(identifier:                        String,
                 orderIdentifier:                   String?,
                 object:                            String,
                 paymentOptions:                    [PaymentOption],
                 currency:                          TapCurrencyCode,
                 merchantCountryCode:               String?) {
        
        self.identifier                     = identifier
        self.orderIdentifier                = orderIdentifier
        self.object                         = object
        self.paymentOptions                 = paymentOptions
        self.currency                       = currency
        self.merchantCountryCode            = merchantCountryCode
    }
}

// MARK: - Decodable
extension TapPaymentOptionsReponseModel: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier                      = try container.decode(String.self, forKey: .identifier)
        let orderIdentifier                 = try container.decodeIfPresent(String.self, forKey: .orderIdentifier)
        let object                          = try container.decode(String.self, forKey: .object)
        var paymentOptions                  = try container.decode([PaymentOption].self, forKey: .paymentOptions)
        let currency                        = try container.decode(TapCurrencyCode.self, forKey: .currency)
        let merchantCountryCode             = try container.decodeIfPresent(String.self, forKey: .merchantCountryCode)
        
        
        paymentOptions = paymentOptions.filter { ($0.paymentType == .Card) }
        paymentOptions = paymentOptions.sorted(by: { $0.orderBy < $1.orderBy })
        
        self.init(identifier:                       identifier,
                  orderIdentifier:                  orderIdentifier,
                  object:                           object,
                  paymentOptions:                   paymentOptions,
                  currency:                         currency,
                  merchantCountryCode:              merchantCountryCode)
    }
}

/// Responsible for helpers method to access data inside the model
extension TapPaymentOptionsReponseModel {
    
    /**
     Gets a specific payment option by id
     - Parameter with: The id of the needed payment option
     - Returns: Payment option if found with the specified id, else nil
     */
    func fetchPaymentOption(with id:String) -> PaymentOption? {
        var requiredPaymentOption:PaymentOption?
        
        // Let us get the needed payment option if any
        let filteredPaymentOptions:[PaymentOption] = paymentOptions.filter{ $0.identifier == id }
        // Make sure at least one option met the requirement
        guard !filteredPaymentOptions.isEmpty else { return requiredPaymentOption }
        // That is it..
        requiredPaymentOption = filteredPaymentOptions.first
        
        return requiredPaymentOption
    }
}
