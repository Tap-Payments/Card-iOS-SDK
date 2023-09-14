//
//  File.swift
//
//
//  Created by Osama Rabie on 09/09/2023.
//

import Foundation


// MARK: - Operator
/// Represents the operator model which contains app identification
@objcMembers public class Operator: NSObject, Codable {
    /// The tap public key
    public var publicKey: String?
    /// Any meta data for further usages
    public var metadata: [String:String]?
    
    /// Represents the operator model which contains app identification
    /// - PArameter publicKey: The tap public key
    /// - Parameter metadata: Any meta data for further usages
    @objc public init(publicKey: String?, metadata: [String:String]?) {
        self.publicKey = publicKey
        self.metadata = metadata
    }
}

// MARK: - Operator convenience initializers and mutators

extension Operator {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Operator.self, from: data)
        self.init(publicKey: me.publicKey, metadata: me.metadata)
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
        publicKey: String?? = nil,
        metadata: [String:String]?? = nil
    ) -> Operator {
        return Operator(
            publicKey: publicKey ?? self.publicKey,
            metadata: metadata ?? self.metadata
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//MARK: - Scope
/// The scope of the intended sdk integration
@objc public enum Scope: Int, RawRepresentable, Codable {
    /// Will generate an authenticated token that can be used to perform charges afterwards
    case Authenticate
    /// Will generate a tap token to be used in charges api afterwards
    case Token
    
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .Authenticate:
            return "Authenticate"
        case .Token:
            return "Token"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue.lowercased() {
        case "authenticate":
            self = .Authenticate
        case "token":
            self = .Token
        default:
            return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try Scope(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .Token
    }
}


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



// MARK: - Authentication
/// A model for the Authentication model to be passed to create an authenticated token
@objcMembers public class Authentication: NSObject, Codable {
    /// The description you want to add to the authentication
    var authenticationDescription: String?
    /// Any optional dictionary of data you want to attach to the authentication process for your own processing
    var metadata: [String:String]?
    /// Important data to identify this authentication process is related to which transaction & order
    var reference: Reference?
    /// Will link this authentication process to a certain invoice
    var invoice: Invoice?
    /// Some data related to identify the shape of the Authentication process itself
    var authentication: AuthenticationClass?
    /// The url you want to post the result of the authentication to (webhook)
    var post: Post?
    
    /// A model for the Authentication model to be passed to create an authenticated token
    /// - Parameters:
    ///     -  description: The description you want to add to the authentication
    ///     - metadata:  Any optional dictionary of data you want to attach to the authentication process for your own processing
    ///     - reference:  Important data to identify this authentication process is related to which transaction & order
    ///     - invoice:  Will link this authentication process to a certain invoice
    ///     - authentication: Some data related to identify the shape of the Authentication process itself
    ///     - post:  The url you want to post the result of the authentication to (webhook)
    @objc public init(description: String?, metadata: [String:String]?, reference: Reference?, invoice: Invoice?, authentication: AuthenticationClass?, post: Post?) {
        self.authenticationDescription = description
        self.metadata = metadata
        self.reference = reference
        self.invoice = invoice
        self.authentication = authentication
        self.post = post
    }
    
    private enum CodingKeys : String, CodingKey {
        case authenticationDescription = "description"
        case metadata, reference, invoice, authentication, post
    }
}

// MARK: Authentication convenience initializers and mutators

extension Authentication {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Authentication.self, from: data)
        self.init(description: me.description, metadata: me.metadata, reference: me.reference, invoice: me.invoice, authentication: me.authentication, post: me.post)
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
        description: String?? = nil,
        metadata: [String:String]?? = nil,
        reference: Reference?? = nil,
        invoice: Invoice?? = nil,
        authentication: AuthenticationClass?? = nil,
        post: Post?? = nil
    ) -> Authentication {
        return Authentication(
            description: description ?? self.authenticationDescription,
            metadata: metadata ?? self.metadata,
            reference: reference ?? self.reference,
            invoice: invoice ?? self.invoice,
            authentication: authentication ?? self.authentication,
            post: post ?? self.post
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AuthenticationClass
/// Some data related to identify the shape of the Authentication process itself
@objcMembers public class AuthenticationClass: NSObject, Codable {
    var channel,purpose: String?
    
    /// Some data related to identify the shape of the Authentication process itself
    /// - Parameters:
    ///     -  channel: The channel which the authentication process is going throug
    ///     - purpose: WHat is the final usage of this authentication process
    @objc public init(channel: String? = "PAYER_BROWSER", purpose: String? = "PAYMENT_TRANSACTION") {
        self.channel = channel
        self.purpose = purpose
    }
}

// MARK: AuthenticationClass convenience initializers and mutators

extension AuthenticationClass {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(AuthenticationClass.self, from: data)
        self.init(channel: me.channel, purpose: me.purpose)
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
        channel: String?? = nil,
        purpose: String?? = nil
    ) -> AuthenticationClass {
        return AuthenticationClass(
            channel: channel ?? self.channel,
            purpose: purpose ?? self.purpose
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Invoice
/// A model to identify an invoice to link to any process afterwards
@objcMembers public class Invoice: NSObject, Codable {
    var id: String?
    
    /// A model to identify an invoice to link to any process afterwards
    /// - Parameter id: The id of the needed invoice
    @objc public init(id: String?) {
        self.id = id
    }
}

// MARK: Invoice convenience initializers and mutators

extension Invoice {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Invoice.self, from: data)
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
    ) -> Invoice {
        return Invoice(
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

// MARK: - Post
/// The url you want to post the result of the authentication to (webhook)
@objcMembers public class Post: NSObject, Codable {
    var url: String?
    /// The url you want to post the result of the authentication to (webhook)
    /// - Parameter url: The url of your server
    @objc public init(url: String?) {
        self.url = url
    }
}

// MARK: Post convenience initializers and mutators

extension Post {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Post.self, from: data)
        self.init(url: me.url)
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
        url: String?? = nil
    ) -> Post {
        return Post(
            url: url ?? self.url
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Reference
/// Important data to identify this authentication process is related to which transaction & order
@objcMembers public class Reference: NSObject, Codable {
    var transaction, order: String?
    /// Important data to identify this authentication process is related to which transaction & order
    /// - Parameter transaction: The transaction id generated by Tap
    /// - Parameter order: The order id generated by Tap
    @objc public init(transaction: String?, order: String?) {
        self.transaction = transaction
        self.order = order
    }
}

// MARK: Reference convenience initializers and mutators

extension Reference {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Reference.self, from: data)
        self.init(transaction: me.transaction, order: me.order)
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
        transaction: String?? = nil,
        order: String?? = nil
    ) -> Reference {
        return Reference(
            transaction: transaction ?? self.transaction,
            order: order ?? self.order
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
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
