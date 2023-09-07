//
//  WebCardSDKConfig.swift
//  TapCardCheckOutKit
//
//  Created by MahmoudShaabanAllam on 06/09/2023.
//

import Foundation
import TapCardVlidatorKit_iOS
import CommonDataModelsKit_iOS



class CardWebMerchant: Codable {
    internal init(id: String) {
        self.id = id
    }
    
    var id: String
}

class CardWebTransaction: Codable {
    internal init(amount: Double = 1, currency: TapCurrencyCode = .SAR) {
        self.amount = amount
        self.currency = currency
    }
    
    var amount:Double = 1
    var currency:TapCurrencyCode = .SAR
}

class CardWebCustomer: Codable {
    internal init(id: String, name: [CardWebCustomerName], nameOnCard: String, editable: Bool, contact: CardWebContact) {
        self.id = id
        self.name = name
        self.nameOnCard = nameOnCard
        self.editable = editable
        self.contact = contact
    }
    
    var id: String
    var name: [CardWebCustomerName]
    var nameOnCard: String
    var editable: Bool
    var contact: CardWebContact
}

class CardWebCustomerName: Codable {
    internal init(lang: String, first: String, last: String, middle: String) {
        self.lang = lang
        self.first = first
        self.last = last
        self.middle = middle
    }
    
    var lang: String
    var first: String
    var last: String
    var middle: String
}

class CardWebContact: Codable {
    internal init(email: String, phone: CardWebPhone) {
        self.email = email
        self.phone = phone
    }
    
    var email: String
    var phone: CardWebPhone
}

class CardWebPhone: Codable {
    internal init(countryCode: String, number: String) {
        self.countryCode = countryCode
        self.number = number
    }
    
    var countryCode: String
    var number: String
}

class CardWebAcceptance: Codable {
    internal init(supportedBrands: [CardBrand], supportedCards: [cardTypes]) {
        self.supportedBrands = supportedBrands
        self.supportedCards = supportedCards
    }
    
    var supportedBrands: [CardBrand]
    var supportedCards: [cardTypes]
}

class CardWebInterface: Codable {
    internal init(local: String, theme: String, edges: String, direction: String) {
        self.local = local
        self.theme = theme
        self.edges = edges
        self.direction = direction
    }
    
    var local: String
    var theme: String
    var edges: String
    var direction: String
}

class CardWebFields: Codable {
    internal init(cardHolder: Bool) {
        self.cardHolder = cardHolder
    }
    
    var cardHolder: Bool
}

class CardWebAddons: Codable {
    internal init(displayPaymentBrands: Bool, loader: Bool, saveCard: Bool) {
        self.displayPaymentBrands = displayPaymentBrands
        self.loader = loader
        self.saveCard = saveCard
    }
    
    var displayPaymentBrands: Bool
    var loader: Bool
    var saveCard: Bool

}

class CardWebSDKConfig: Codable {
  
    
    var publicKey: String
    var merchant: CardWebMerchant
    var transaction: CardWebTransaction
    var customer: CardWebCustomer
    var acceptance: CardWebAcceptance
    var fields: CardWebFields
    var addons: CardWebAddons
    var interface: CardWebInterface
    
    internal init(publicKey: String, merchant: CardWebMerchant, transaction: CardWebTransaction, customer: CardWebCustomer, acceptance: CardWebAcceptance, fields: CardWebFields, addons: CardWebAddons, interface: CardWebInterface) {
        self.publicKey = publicKey
        self.merchant = merchant
        self.transaction = transaction
        self.customer = customer
        self.acceptance = acceptance
        self.fields = fields
        self.addons = addons
        self.interface = interface
    }
}
