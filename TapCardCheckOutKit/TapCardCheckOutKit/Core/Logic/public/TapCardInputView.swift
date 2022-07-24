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
import TapCardScanner_iOS
import AVFoundation

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
    private var currentTapCard:TapCard? {
        didSet{
            postCardDataChange()
        }
    }
    
    /// Holds the latest detected card brand
    private var cardBrand: CardBrand?
    /// Holds the latest validation status for the entered card data
    private var validation: CrardInputTextFieldStatusEnum = .Invalid {
        didSet{
            selectCorrectBrand()
        }
    }
    
    /// The full scanner object that we will use to start scanning on demand
    private var fullScanner:TapFullScreenScannerViewController = TapFullScreenScannerViewController()
    
    /// A reference to the localisation manager
    private var locale:String = "en" {
        didSet {
            TapLocalisationManager.shared.localisationLocale = locale
            //initUI()
        }
    }
    
    /// Indicates whether ot not the card form will ask for the card holder name
    private var collectCardHolderName:Bool = false {
        didSet {
            //initUI()
        }
    }
    /// This is the height constraing of the card brands view. We will use to control its height based on its visibility
    @IBOutlet weak var carddbrandsBarHeightConstraint: NSLayoutConstraint!
    
    /// Indicates whether ot not the card form will show the card brands bar
    private var showCardBrands:Bool = false {
        didSet {
            //setupCardBrandsBar()
        }
    }
    /// Indicates whether ot not the card scanner. Default is false
    private var showCardScanner:Bool = false
    
    /// The ui customization to the full screen scanner borer color and to show a blut
    private var tapScannerUICustomization:TapFullScreenUICustomizer = .init()
    
    /// The currency you want to show the card brands that accepts it. Default is KWD
    private var transactionCurrency: TapCurrencyCode = .KWD
    
    /// The UIViewController that will display the scanner into
    private var presentScannerInViewController:UIViewController?
    
    /// Decides which cards shall we accept
    private var allowedCardType:cardTypes = .All
    
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
     - Parameter showCardScanner: Indicates whether ot not the card scanner. Default is false
     - Parameter transactionCurrency: The currency you want to show the card brands that accepts it. Default is KWD
     - Parameter presentScannerInViewController: The UIViewController that will display the scanner into
     - Parameter blurCardScannerBackground: The ui customization to the full screen scanner borer color and to show a blur
     - Parameter allowedCardTypes: Decides which cards shall we accept. Default is All
     */
    
    @objc public func setupCardForm(locale:String = "en", collectCardHolderName:Bool = false, showCardBrandsBar:Bool = false, showCardScanner:Bool = false, tapScannerUICustomization:TapFullScreenUICustomizer = .init() , transactionCurrency:TapCurrencyCode = .KWD, presentScannerInViewController:UIViewController?, allowedCardTypes:cardTypes = .All) {
        // Set the locale
        self.locale = locale
        // Set the collection name ability
        self.collectCardHolderName = collectCardHolderName
        // Set the card bar ability
        self.showCardBrands = showCardBrandsBar
        // The ui customization to the full screen scanner borer color and to show a blur
        self.tapScannerUICustomization = tapScannerUICustomization
        // Set the needed currency
        self.transactionCurrency = transactionCurrency
        // Indicates whether ot not the card scanner. Default is false
        self.showCardScanner = showCardScanner
        // The UIViewController that will display the scanner into
        self.presentScannerInViewController = presentScannerInViewController
        // Decides which cards shall we accept
        self.allowedCardType = allowedCardTypes
        // Adjust the UI now
        initUI()
        // Init the card brands bar
        setupCardBrandsBar()
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
        guard let _ = sharedNetworkManager.dataConfig.sdkSettings else {
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
        
        sharedNetworkManager.callCardTokenAPI(cardTokenRequestModel: TapCreateTokenWithCardDataRequest(card: nonNullTokenizeCard),onResponeReady: onResponeReady, onErrorOccured: onErrorOccured)
    }
    
    
    
    // MARK:- Private functions
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.contentView = setupXIB()
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
        
        // Make sure we need to show it first
        guard showCardBrands else { return }
        // Setup the card brands bar view with the data source
        tapCardPhoneListView.setupView(with: tapCardPhoneListViewModel)
        
        // Set card brands datasource
        setupCardBrandsBarDataSource()
    }
    
    /// Will fetch the correct card brands from the loaded payment options based on the transaction currency
    private func setupCardBrandsBarDataSource() {
        // Dummy data source data for now
        dataSource = Array(sharedNetworkManager.dataConfig.paymentOptions?.toTapCardPhoneIconViewModel(supportsCurrency: transactionCurrency) ?? [])
        // Update the card input brands
        tapCardInput.allowedCardBrands = dataSource.map{ $0.associatedCardBrand.rawValue }
        
        DispatchQueue.main.async { [weak self] in
            self?.tapCardPhoneListView.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.1, options: []) {
                // Apply the new data source
                self?.tapCardPhoneListViewModel.dataSource = self?.dataSource ?? []
                // Auto select the card section
                self?.tapCardPhoneListViewModel.select(segment: "cards")
                // Show it now
                self?.tapCardPhoneListView.alpha = 1
            }
        }
    }
    
    
    /**
     Used to fetch the card brand with all the supported schemes under it as per the payment options api response
     - Parameter for cardBrand: The card brand we need to know all the schemes it supports
     - Returns: List of supported schemes by the provided brand
     */
    private func fetchSupportedCardSchemes(for cardBrand:CardBrand?) -> CardBrandWithSchemes? {
        
        guard let cardBrand = cardBrand,
              let _ = sharedNetworkManager.dataConfig.paymentOptions,
              let _ = sharedNetworkManager.dataConfig.tapBinLookUpResponse else {
            return nil
        }
        
        return .init(sharedNetworkManager.dataConfig.paymentOptions?.filter{  $0.brand == cardBrand  }.first?.supportedCardBrands ?? [], cardBrand)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)) { [weak self] in
            // let us highlight the detected brand with its validation status
            self?.tapCardPhoneListViewModel.select(brand: cardBrand, with: self?.validation == .Valid)
        }
    }
    
    /// Does the needed pre logic to shape the card input UI forum
    private func initUI() {
        // Let it go with the UI constraints
        tapCardInput.translatesAutoresizingMaskIntoConstraints = false
        // No saving card and no scanning option for the card kit
        tapCardInput.showSaveCardOption = false
        tapCardInput.showScanningOption = showCardScanner
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
        var supportedBrands = Array(sharedNetworkManager.dataConfig.paymentOptions ?? [] ).map{ $0.brand.rawValue }
        if supportedBrands.isEmpty {
            supportedBrands = CardBrand.allCases.map{ $0.rawValue }
        }
        supportedBrands = CardBrand.allCases.map{ $0.rawValue }
        tapCardInput.setup(for: .InlineCardInput, showCardName: collectCardHolderName, allowedCardBrands: supportedBrands)
        // Let us listen to the card input ui callbacks if needed
        tapCardInput.delegate = self
    }
    
    /// Handles logic needed to be done after changing the card data
    private func postCardDataChange() {
        // let us call binlook up if possible
        sharedNetworkManager.callBinLookup(for: currentTapCard?.tapCardNumber,onResponeReady: { [weak self] _ in
            self?.handleBinLookUp()
        })
    }
    
    /// Executes needed logic upon recieving a new look up response
    private func handleBinLookUp() {
        // Check if the card type is an allowed one
        guard let binResponse = sharedNetworkManager.dataConfig.tapBinLookUpResponse else { return }
        
        if allowedCardType == .All || binResponse.cardType.cardType == allowedCardType {
            // Then it is allowed to proceed on with it :)
            // Set the favorite card brand as per the binlook up response
            CardValidator.favoriteCardBrand = fetchSupportedCardSchemes(for: sharedNetworkManager.dataConfig.tapBinLookUpResponse?.scheme?.cardBrand)
        }else{
            // Let us reset the card data and inform the delegate that the user tried entering a wrong card number
            self.tapCardInput.reset()
        }
    }
    
    /// Handle the click on scan card by the user
    private func showFullScanner() {
        // Make sure we have a UIViewcontroller to display the full screen scanner on
        guard let presentScannerInViewController = presentScannerInViewController else {
            return
        }

        // First grant the authorization to use the camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            if response {
                //access granted
                DispatchQueue.main.async {[weak self] in
                    self?.fullScanner = .init(delegate: self, uiCustomization: self?.tapScannerUICustomization ?? .init())
                    presentScannerInViewController.present((self?.fullScanner)!, animated: true)
                }
            }else {
                
            }
        }
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
        self.tapCardInput.reset()
        showFullScanner()
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

extension TapCardInputView: TapCreditCardScannerViewControllerDelegate {
    public func creditCardScannerViewControllerDidCancel(_ viewController: TapFullScreenScannerViewController) {
        viewController.dismiss(animated: true)
    }
    
    public func creditCardScannerViewController(_ viewController: TapFullScreenScannerViewController, didErrorWith error: Error) {
        viewController.dismiss(animated: true)
    }
    
    public func creditCardScannerViewController(_ viewController: TapFullScreenScannerViewController, didFinishWith card: TapCard) {
        //print("\(card.name ?? "")\n\(card.number ?? "")\n\(card.expireDate?.month)\n\(card.expireDate?.year)")
        viewController.dismiss(animated: true,completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                [weak self] in
                self?.tapCardInput.setCardData(tapCard: .init(tapCardNumber: card.tapCardNumber?.tap_substring(to: 6)),then: false)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                [weak self] in
                self?.tapCardInput.setCardData(tapCard: .init(tapCardNumber: card.tapCardNumber),then: true)
            })
        })
    }
    
    
}
