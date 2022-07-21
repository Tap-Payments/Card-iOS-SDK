//
//  TapCardInputView.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 21/03/2022.
//

import UIKit
import TapCardInputKit_iOS
import TapCardVlidatorKit_iOS
import CommonDataModelsKit_iOS
import TapThemeManager2020
import LocalisationManagerKit_iOS
import TapUIKit_iOS
import MOLH

/// Represents the on the shelf card forum entry view
@objc public class TapCardInputView : UIView {
    /// Represents the main holding view
    @IBOutlet var contentView: UIView!
    /// Represents the UI part of the embedded card entry forum
    @IBOutlet weak var tapCardInput: TapCardInput!
    /// Represents the UI part of showing the card brands bar
    @IBOutlet weak var tapCardPhoneListView: TapCardPhoneBarList!
        
    /// Represents the view model for handling the card brands bar
    let tapCardPhoneListViewModel:TapCardPhoneBarListViewModel = .init()
    /// Represents the data source for the card brands bar
    var dataSource:[TapCardPhoneIconViewModel] = []
    
    /// Holds the latest card info provided by the user
    private var currentTapCard:TapCard?
    
    /// Holds the latest detected card brand
    private var cardBrand: CardBrand?
    /// Holds the latest validation status for the entered card data
    private var validation: CrardInputTextFieldStatusEnum = .Invalid {
        didSet{
            selectCorrectBrand()
        }
    }
    
    /// A reference to the localisation manager
    private var locale:String = "en" {
        didSet {
            TapLocalisationManager.shared.localisationLocale = locale
            initUI()
        }
    }
    
    /// Indicates whether ot not the card form will ask for the card holder name
    private var collectCardHolderName:Bool = false {
        didSet {
            initUI()
        }
    }
    /// This is the height constraing of the card brands view. We will use to control its height based on its visibility
    @IBOutlet weak var carddbrandsBarHeightConstraint: NSLayoutConstraint!
    
    /// Indicates whether ot not the card form will show the card brands bar
    private var showCardBrands:Bool = false {
        didSet {
            setupCardBrandsBar()
        }
    }
    
    /// The currency you want to show the card brands that accepts it. Default is KWD
    private var transactionCurrency: TapCurrencyCode = .KWD
    
    
    // Mark:- Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    // MARK:- Public functions
    
    /**
     Call this method for optional attributes defining and configueation for the card form
     - Parameter locale: The locale identifer(e.g. en, ar, etc.0 Default value is en
     - Parameter collectCardHolderName: Indicates whether ot not the card form will ask for the card holder name. Default is false
     - Parameter showCardBrandsBar: Indicates whether ot not the card form will show the card brands bar. Default is false
     - Parameter transactionCurrency: The currency you want to show the card brands that accepts it. Default is KWD
     */
    
    @objc public func setupCardForm(locale:String = "en", collectCardHolderName:Bool = false, showCardBrandsBar:Bool = false, transactionCurrency:TapCurrencyCode = .KWD) {
        // Set the locale
        self.locale = locale
        // Set the collection name ability
        self.collectCardHolderName = collectCardHolderName
        // Set the card bar ability
        self.showCardBrands = showCardBrandsBar
        // Set the needed currency
        self.transactionCurrency = transactionCurrency
    }
    
    /**
     Call this method to change the currency at run time. Please note that this will reset the card data and change the visible card brands.
     - Parameter to currency: The new transaction currency
     */
    @objc public func updateTransactionCurrenct(to currency:TapCurrencyCode) {
        // set the new currency
        self.transactionCurrency = currency
        // reset card form data
        tapCardInput.reset()
        // reload the bar view
        setupCardBrandsBar()
    }
    
    /**
     Handles tokenizing the current card data.
     - Parameter onResponeReady: A callback to listen when a token is successfully generated
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     */
    @objc public func tokenizeCard(onResponeReady: @escaping (Token) -> () = {_ in}, onErrorOccured: @escaping(Error)->() = {_ in}) {
        // Check that the card kit is already initilzed
        guard let _ = NetworkManager.shared.dataConfig.sdkSettings else {
            onErrorOccured("You have to call the initCardForm method first. This allows the card form to get the data needed to communicate with Tap's backend apis.")
            return
        }
        // Check that the user entered a valid card data first
        guard let nonNullCard = currentTapCard,
              validation == .Valid,
        let nonNullTokenizeCard:CreateTokenCard = try? .init(card: nonNullCard, address: nil) else {
            onErrorOccured("The user didn't enter a valid card data to tokenize. Please prompt the user to do so first.")
            return
        }
        
        NetworkManager.shared.callCardTokenAPI(cardTokenRequestModel: TapCreateTokenWithCardDataRequest(card: nonNullTokenizeCard),onResponeReady: onResponeReady, onErrorOccured: onErrorOccured)
    }
    
    
    
    // MARK:- Private functions
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.contentView = setupXIB()
        initUI()
        // Init the card brands bar
        setupCardBrandsBar()
    }
    
    /// DOes the needed logic to fill in the card brands bar
    private func setupCardBrandsBar() {
        
        // based on the value we decide whether we will show it or we will hide it
        tapCardPhoneListView.isHidden = !showCardBrands
        
        // Afterwords, we need to set its height constraint based on its visibility
        DispatchQueue.main.async { [weak self] in
            self?.carddbrandsBarHeightConstraint.constant = (self?.showCardBrands ?? false) ? 49 : 0
            self?.tapCardPhoneListView.layoutIfNeeded()
            self?.layoutIfNeeded()
        }
        // Setup the card brands bar view with the data source
        tapCardPhoneListView.setupView(with: tapCardPhoneListViewModel)
        
        // Set card brands datasource
        setupCardBrandsBarDataSource()
    }
    
    /// Will fetch the correct card brands from the loaded payment options based on the transaction currency
    private func setupCardBrandsBarDataSource() {
        // Dummy data source data for now
        dataSource = Array(NetworkManager.shared.dataConfig.paymentOptions?.toTapCardPhoneIconViewModel(supportsCurrency: transactionCurrency) ?? [])
        
        
        
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 1, delay: 0, options: []) {
                self?.tapCardPhoneListView.alpha = 0
            } completion: { _ in
                self?.tapCardPhoneListViewModel.dataSource = self?.dataSource ?? []
                // Auto select the card section
                self?.tapCardPhoneListViewModel.select(segment: "cards")
                UIView.animate(withDuration: 1, delay: 1, options: []) {
                    self?.tapCardPhoneListView.alpha = 1
                }
            }

        }/*
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) { [weak self] in
            self?.tapCardPhoneListViewModel.dataSource = self?.dataSource ?? []
            // Auto select the card section
            self?.tapCardPhoneListViewModel.select(segment: "cards")
        }*/
    }
    
    /// Responsible for deciding which card brand should be underlined if any
    private func selectCorrectBrand() {
        // Check what type of brands do we have
        guard let cardBrand = cardBrand,
              cardBrand != .unknown else {
                  // We just reset the selection for now
                  tapCardPhoneListViewModel.resetCurrentSegment()
                  return
        }
        // let us highlight the detected brand with its validation status
        tapCardPhoneListViewModel.select(brand: cardBrand, with: validation == .Valid)
    }
    
    /// Does the needed pre logic to shape the card input UI forum
    private func initUI() {
        // Let it go with the UI constraints
        tapCardInput.translatesAutoresizingMaskIntoConstraints = false
        // No saving card and no scanning option for the card kit
        tapCardInput.showSaveCardOption = false
        tapCardInput.showScanningOption = false
        // Let us configure the theming and the internal variabls of the card input forum
        configureCardInputUI()
    }
    
    
    /**
     Handles initializing the card forum engine with the required data to be able to tokenize on demand. It calls the Init api
     - Parameter dataConfig: The data configured by you as a merchant (e.g. secret key, locale, etc.)
     */
    private func initCardForm() {
        // Check first of the data manager was already populated with required data
        guard let _ = TapCardForumConfiguration.shared.dataConfig?.sdkSettings else {
            // This means the app didn't populate reuired data to talk to backend correctly before loading the view. Hence, we hide it
            DispatchQueue.main.async { [weak self] in
                self?.tapCardInput.isHidden = true
                print("Tap Card Forum error : Please populate data in TapCardForumConfiguration.shared first before showing the view")
            }
            return
        }
    }
    
    
    ///  Initiates the card input forum by adjusting the UI and defining the card brands
    private func configureCardInputUI() {
        // As per the requirement, the card forum kit will not care about allowed card brands,
        // Hence we declare it to accept all cards.
        tapCardInput.setup(for: .InlineCardInput, showCardName: collectCardHolderName, allowedCardBrands: CardBrand.allCases.map{ $0.rawValue })
        // Let us listen to the card input ui callbacks if needed
        tapCardInput.delegate = self
    }
}

// MARK:- Card Forum UI delegate

extension TapCardInputView : TapCardInputProtocol {
    public func cardDataChanged(tapCard: TapCard) {
        currentTapCard = tapCard
    }
    
    public func brandDetected(for cardBrand: CardBrand, with validation: CrardInputTextFieldStatusEnum) {
        self.cardBrand = cardBrand
        self.validation = validation
    }
    
    public func scanCardClicked() {
        
    }
    
    public func saveCardChanged(enabled: Bool) {
        
    }
    
    public func dataChanged(tapCard: TapCard) {
        currentTapCard = tapCard
    }
    
    public func shouldAllowChange(with cardNumber: String) -> Bool {
        return true
    }
}
