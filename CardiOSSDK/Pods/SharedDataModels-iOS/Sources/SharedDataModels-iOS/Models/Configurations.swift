//
//  File.swift
//  
//
//  Created by Osama Rabie on 09/09/2023.
//

import Foundation
// MARK: - Acceptance
/// The acceptance details for the transaction
@objcMembers public class Acceptance: NSObject, Codable {
    public var supportedBrands, supportedCards: [String]?
    /**
     The acceptance details for the transaction
     - Parameters:
     - supportedBrands: The supported card brands for the customer to pay with. [AMEX,VISA,MADA,OMANNET,MEEZA,MASTERCARD]
     - supportedCards: The funding source for the cards the customer can pay with. [CREDIT,DEBIT]
     */
    @objc public init(supportedBrands: [String]?, supportedCards: [String]?) {
        self.supportedBrands = supportedBrands
        self.supportedCards = supportedCards
    }
}

// MARK: Acceptance convenience initializers and mutators

extension Acceptance {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Acceptance.self, from: data)
        self.init(supportedBrands: me.supportedBrands, supportedCards: me.supportedCards)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        supportedBrands: [String]?? = nil,
        supportedCards: [String]?? = nil
    ) -> Acceptance {
        return Acceptance(
            supportedBrands: supportedBrands ?? self.supportedBrands,
            supportedCards: supportedCards ?? self.supportedCards
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Addons
/// Defines some UI/UX addons enablement
@objcMembers public class Addons: NSObject, Codable {
    public var displayPaymentBrands, loader, saveCard: Bool?
    /**
     Defines some UI/UX addons enablement
     - Parameters:
     - displayPaymentBrands: Defines to show the supported card brands logos
     - loader: Defines to show a loader on top of the card when it is in a processing state
     - saveCard: Defines it is required to show save card option to the customer
     */
    @objc public init(displayPaymentBrands: Bool = false, loader: Bool = false, saveCard: Bool = false) {
        self.displayPaymentBrands = displayPaymentBrands
        self.loader = loader
        self.saveCard = saveCard
    }
}

// MARK: Addons convenience initializers and mutators

extension Addons {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Addons.self, from: data)
        self.init(displayPaymentBrands: me.displayPaymentBrands ?? false, loader: me.loader ?? false, saveCard: me.saveCard ?? false)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        displayPaymentBrands: Bool = false,
        loader: Bool = false,
        saveCard: Bool = false
    ) -> Addons {
        return Addons(
            displayPaymentBrands: displayPaymentBrands,
            loader: loader,
            saveCard: saveCard
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Customer
/// The Tap customer details
@objcMembers public class Customer: NSObject, Codable {
    public var id: String?
    public var name: [Name]?
    public var nameOnCard: String?
    public var editable: Bool?
    public var contact: Contact?
    
    /**
     The Tap customer details
     - Parameters:
     - id: Tap id for the customer
     - name: The customer's name(s)
     - editable: If the customer can edit the card holder name field
     - contact: The customer's contact details
     */
    @objc public init(id: String?, name: [Name]?, nameOnCard: String?, editable: Bool = false, contact: Contact?) {
        self.id = id
        self.name = name
        self.nameOnCard = nameOnCard
        self.editable = editable
        self.contact = contact
    }
}

// MARK: Customer convenience initializers and mutators

extension Customer {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Customer.self, from: data)
        self.init(id: me.id, name: me.name, nameOnCard: me.nameOnCard, editable: me.editable ?? false, contact: me.contact)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: String?? = nil,
        name: [Name]?? = nil,
        nameOnCard: String?? = nil,
        editable: Bool = false,
        contact: Contact?? = nil
    ) -> Customer {
        return Customer(
            id: id ?? self.id,
            name: name ?? self.name,
            nameOnCard: nameOnCard ?? self.nameOnCard,
            editable: editable,
            contact: contact ?? self.contact
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Contact
/// The customer's contact details
@objcMembers public class Contact: NSObject, Codable {
    public var email: String?
    public var phone: Phone?
    
    /**
     The customer's contact details
     - Parameters:
     - email: The custpmer's email
     - phone: The customer' phone
     */
    @objc public init(email: String?, phone: Phone?) {
        self.email = email
        self.phone = phone
    }
}

// MARK: Contact convenience initializers and mutators

extension Contact {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Contact.self, from: data)
        self.init(email: me.email, phone: me.phone)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        email: String?? = nil,
        phone: Phone?? = nil
    ) -> Contact {
        return Contact(
            email: email ?? self.email,
            phone: phone ?? self.phone
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Phone
/// The customer's phone
@objcMembers public class Phone: NSObject, Codable {
    public var countryCode, number: String?
    
    /**
     The customer's phone
     - Parameters:
     - countryCode: the country code for the phone
     - number: The actual phone number
     */
    @objc public init(countryCode: String?, number: String?) {
        self.countryCode = countryCode
        self.number = number
    }
}

// MARK: Phone convenience initializers and mutators

extension Phone {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Phone.self, from: data)
        self.init(countryCode: me.countryCode, number: me.number)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        countryCode: String?? = nil,
        number: String?? = nil
    ) -> Phone {
        return Phone(
            countryCode: countryCode ?? self.countryCode,
            number: number ?? self.number
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Name
/// Tap customer's name(s)
@objcMembers public class Name: NSObject, Codable {
    public var lang, first, last, middle: String?
    /**
     Customer's name(s)
     - Parameters:
     - lang: The lcoale of the provided name
     - first: The first name
     - last: The last name
     - middle: The middle name
     */
    @objc public init(lang: String?, first: String?, last: String?, middle: String?) {
        self.lang = lang
        self.first = first
        self.last = last
        self.middle = middle
    }
}

// MARK: Name convenience initializers and mutators

extension Name {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Name.self, from: data)
        self.init(lang: me.lang, first: me.first, last: me.last, middle: me.middle)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        lang: String?? = nil,
        first: String?? = nil,
        last: String?? = nil,
        middle: String?? = nil
    ) -> Name {
        return Name(
            lang: lang ?? self.lang,
            first: first ?? self.first,
            last: last ?? self.last,
            middle: middle ?? self.middle
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Fields
/// Defines the fields visibility
@objcMembers public class Fields: NSObject, Codable {
    public var cardHolder: Bool?
    /**
     Defines the fields visibility
     - Parameter cardHolder: Defines whther or not to show the card holder name field
     */
    @objc public init(cardHolder: Bool = false) {
        self.cardHolder = cardHolder
    }
}

// MARK: Fields convenience initializers and mutators

extension Fields {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Fields.self, from: data)
        self.init(cardHolder: me.cardHolder ?? false)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        cardHolder: Bool = false
    ) -> Fields {
        return Fields(
            cardHolder: cardHolder
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Interface
/// Defines some UI related configurations
@objcMembers public class Interface: NSObject, Codable {
    public var locale, theme, edges, direction: String?
    /// Defines some UI related configurations
    /// - Parameters:
    /// - locale: The language of the sdk `ar` or `en`
    /// - theme: The theme of the  sdk `light` or `dark`
    /// - edges: The edges of the  sdk `curved` or `flat`
    /// - direction: The edges of the  sdk `ltr` or `rtl`
    @objc public init(locale: String?, theme: String?, edges: String?, direction: String?) {
        self.locale = locale
        self.theme = theme
        self.edges = edges
        self.direction = direction
    }
}

// MARK: Interface convenience initializers and mutators

extension Interface {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Interface.self, from: data)
        self.init(locale: me.locale, theme: me.theme, edges: me.edges, direction: me.direction)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        locale: String?? = nil,
        theme: String?? = nil,
        edges: String?? = nil,
        direction: String?? = nil
    ) -> Interface {
        return Interface(
            locale: locale ?? self.locale,
            theme: theme ?? self.theme,
            edges: edges ?? self.edges,
            direction: direction ?? self.direction
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Merchant
/// The tap's merchant model
@objcMembers public class Merchant: NSObject, Codable {
    
    public var id: String?
    /// The merchant model
    /// - Parameter id: The tap merchant id
    @objc public init(id: String?) {
        self.id = id
    }
}

// MARK: Merchant convenience initializers and mutators

extension Merchant {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Merchant.self, from: data)
        self.init(id: me.id)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: String?? = nil
    ) -> Merchant {
        return Merchant(
            id: id ?? self.id
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Transaction
@objcMembers public class Transaction: NSObject, Codable {
    public var amount: Int?
    public var currency: String?
    
    @objc public init(amount: Int = 1, currency: String?) {
        self.amount = amount
        self.currency = currency
    }
}

// MARK: Transaction convenience initializers and mutators

extension Transaction {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Transaction.self, from: data)
        self.init(amount: me.amount ?? 1, currency: me.currency)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        amount: Int = 1,
        currency: String?? = nil
    ) -> Transaction {
        return Transaction(
            amount: amount,
            currency: currency ?? self.currency
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
