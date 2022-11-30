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
import TapCardScanner_iOS
import AVFoundation
/*//import FirebaseAnalytics
//import FirebaseCore

/// A protorocl to communicate with the three ds web view controller
internal protocol ThreeDSViewControllerDelegate {
    /// Instruct the controller to dismiss itself
    func disimiss()
    
}


/// A protocol to listen to fired events form the card kit
@objc public protocol TapCardInputDelegate {
    @objc func errorOccured(with error:CardKitErrorType, message:String)
    /**
     Be updated by listening to events fired from the card kit
     - Parameter with event: The event just fired
     */
    @objc func eventHappened(with event:CardKitEventType)
}

/// Represents the on the shelf card forum entry view
@objc public class TapCardInputView : UIView {
    /// Represents the main holding view
    @IBOutlet var contentView: UIView!
    /// Represents the UI part of the embedded card entry forum
    @IBOutlet public weak var tapCardInput: TapCardInput!
    /// Represents the UI part of showing the card brands bar
    @IBOutlet weak var tapCardPhoneListView: TapCardPhoneBarList!
        
    /// Represents the view model for handling the card brands bar
    let tapCardPhoneListViewModel:TapCardPhoneBarListViewModel = .init()
    /// Represents the data source for the card brands bar
    var dataSource:[TapCardPhoneIconViewModel] = []
    
    /// Holds the latest card info provided by the user
    internal var currentTapCard:TapCard? {
        didSet{
            postCardDataChange()
        }
    }
    
    /// Holds the latest detected card brand
    internal var cardBrand: CardBrand?
    /// Holds the latest validation status for the entered card data
    internal var validation: CrardInputTextFieldStatusEnum = .Invalid {
        didSet{
            selectCorrectBrand()
        }
    }
    
    /// deines whether to show the detected brand icon besides the card number instead of the the palceholder
    private var showCardBrandIcon:Bool = true
    
    /// The full scanner object that we will use to start scanning on demand
    private var fullScanner:TapFullScreenScannerViewController?// = TapFullScreenScannerViewController(dataSource: self)
    
    /// The webview model handler
    private var webViewModel:TapWebViewModel = .init()
    
    /// A protorocl to communicate with the three ds web view controller
    internal var threeDSDelegate: ThreeDSViewControllerDelegate?
    
    /// The parent controller will be used to present the web view whenever a 3DS is required to save the card details
    private var parentController:UIViewController?
    
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
    private var tapScannerUICustomization:TapFullScreenUICustomizer? = .init()
    
    /// The UIViewController that will display the scanner into
    private var presentScannerInViewController:UIViewController?
    
    /// Decides which cards shall we accept
    private var allowedCardType:cardTypes = .All
    
    /// A preloading value for the card holder name if needed
    internal var preloadCardHolderName:String = ""
    /// Indicates whether or not the user can edit the card holder name field. Default is true
    internal var editCardName:Bool = true
    
    /// A delegate listens for needed actions and callbacks
    internal var tapCardInputDelegate:TapCardInputDelegate?
    
    // Mark:- Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    //MARK: - Public functions
    
    /**
     Call this method for optional attributes defining and configueation for the card form
     - Parameter locale: The locale identifer(e.g. en, ar, etc.0 Default value is en
     - Parameter collectCardHolderName: Indicates whether ot not the card form will ask for the card holder name. Default is false
     - Parameter showCardBrandsBar: Indicates whether ot not the card form will show the card brands bar. Default is false
     - Parameter showCardScanner: Indicates whether ot not the card scanner. Default is false
     - Parameter tapScannerUICustomization: The ui customization to the full screen scanner borer color and to show a blur
     - Parameter transactionCurrency: The currency you want to show the card brands that accepts it. Default is KWD
     - Parameter presentScannerInViewController: The UIViewController that will display the scanner into
     - Parameter blurCardScannerBackground: The ui customization to the full screen scanner borer color and to show a blur
     - Parameter allowedCardTypes: Decides which cards shall we accept. Default is All
     - Parameter tapCardInputDelegate: A delegate listens for needed actions and callbacks
     - Parameter preloadCardHolderName:  A preloading value for the card holder name if needed
     - Parameter editCardName: Indicates whether or not the user can edit the card holder name field. Default is true
     - Parameter showCardBrandIcon:deines whether to show the detected brand icon besides the card number instead of the placeholdder
     */
    
    @objc public func setupCardForm(locale:String = "en", collectCardHolderName:Bool = false, showCardBrandsBar:Bool = false, showCardScanner:Bool = false, tapScannerUICustomization:TapFullScreenUICustomizer? = .init() , transactionCurrency:TapCurrencyCode = .KWD, presentScannerInViewController:UIViewController?, allowedCardTypes:cardTypes = .All, tapCardInputDelegate:TapCardInputDelegate? = nil, preloadCardHolderName:String = "", editCardName:Bool = true, showCardBrandIcon:Bool = true) {
        // Set the locale
        self.locale = locale
        // Set the collection name ability
        self.collectCardHolderName = collectCardHolderName
        // Set the card bar ability
        self.showCardBrands = showCardBrandsBar
        // The ui customization to the full screen scanner borer color and to show a blur
        self.tapScannerUICustomization = tapScannerUICustomization
        // Set the needed currency
        sharedNetworkManager.dataConfig.transactionCurrency = transactionCurrency
        // Indicates whether ot not the card scanner. Default is false
        self.showCardScanner = showCardScanner
        // The UIViewController that will display the scanner into
        self.presentScannerInViewController = presentScannerInViewController
        // Decides which cards shall we accept
        self.allowedCardType = allowedCardTypes
        // A delegate listens for needed actions and callbacks
        self.tapCardInputDelegate = tapCardInputDelegate
        /// Set the preloading value for card name
        self.preloadCardHolderName = preloadCardHolderName
        /// Set the editibility for the card name field
        self.editCardName = editCardName
        /// deines whether to show the detected brand icon besides the card number instead of the placeholdder
        self.showCardBrandIcon = showCardBrandIcon
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
        sharedNetworkManager.dataConfig.transactionCurrency = currency
        // reset card form data
        tapCardInput.reset()
        // reload the bar view
        setupCardBrandsBar()
    }
    
    /**
     Handles tokenizing the current card data.
     - Parameter onResponeReady: A callback to listen when a token is successfully generated
     - Parameter onErrorOccured: A callback to listen when tokenization fails with error message and the validity of all the card fields for your own interest
     */
    @objc public func tokenizeCard(onResponeReady: @escaping (Token) -> () = {_ in}, onErrorOccured: @escaping(Error,CardFieldsValidity)->() = {_,_  in}) {
        // get the validity of all fields
        let (cardNumberValidationStatus, cardExpiryValidationStatus, cardCVVValidationStatus, cardNameValidationStatus) = tapCardInput.fieldsValidationStatuses()
        
        let cardFieldsValidity = CardFieldsValidity(cardNumberValidationStatus: cardNumberValidationStatus, cardExpiryValidationStatus: cardExpiryValidationStatus, cardCVVValidationStatus: cardCVVValidationStatus, cardNameValidationStatus: cardNameValidationStatus)
        
        // Check that the card kit is already initilzed
        guard let _ = sharedNetworkManager.dataConfig.sdkSettings else {
            onErrorOccured("You have to call the initCardForm method first. This allows the card form to get the data needed to communicate with Tap's backend apis.",cardFieldsValidity)
            return
        }
        
        // Check that the user entered a valid card data first
        guard let nonNullCard = currentTapCard,
              validation == .Valid,
              allFieldsAreValid(),
        let nonNullTokenizeCard:CreateTokenCard = try? .init(card: nonNullCard, address: nil) else {
            onErrorOccured("The user didn't enter a valid card data to tokenize. Please prompt the user to do so first.",cardFieldsValidity)
            return
        }
        tapCardInputDelegate?.eventHappened(with: .TokenizeStarted)
        sharedNetworkManager.callCardTokenAPI(cardTokenRequestModel: TapCreateTokenWithCardDataRequest(card: nonNullTokenizeCard)) { [weak self] token in
            self?.tapCardInputDelegate?.eventHappened(with: .TokenizeEnded)
            onResponeReady(token)
        } onErrorOccured: { [weak self] error in
            self?.tapCardInputDelegate?.eventHappened(with: .TokenizeEnded)
            onErrorOccured(error, cardFieldsValidity)
        }

    }
    
    
    /**
     Handles tokenizing the current card data.
     - Parameter customer: The customer to save the card with.
     - Parameter parentController: The parent controller will be used to present the web view whenever a 3DS is required to save the card details
     - Parameter metadata: Metdata object will be a representation of [String:String] dictionary to be used whenever such a common model needed
     - Parameter enforce3DS: Should we always ask for 3ds while saving the card. Default is true
     - Parameter onResponeReady: A callback to listen when a the save card is finished successfully. Will provide all the details about the saved card data
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     - Parameter on3DSWebViewWillAppear: A callback to tell the consumer app the 3ds web view will start
     - Parameter on3DSWebViewDismissed: A callback to tell he consumer app the 3ds web view is over
     */
    @objc public func saveCard(customer:TapCustomer, parentController:UIViewController,
                               metadata:TapMetadata? = nil,
                               enforce3DS:Bool = true,
                               onResponeReady: @escaping (TapCreateCardVerificationResponseModel) -> () = {_ in},
                               onErrorOccured: @escaping(Error?,TapCreateCardVerificationResponseModel?,CardFieldsValidity)->() = { _,_,_ in},
                               on3DSWebViewWillAppear: @escaping()->() = {},
                               on3DSWebViewDismissed: @escaping()->() = {}) {
        
        
        let (cardNumberValidationStatus, cardExpiryValidationStatus, cardCVVValidationStatus, cardNameValidationStatus) = tapCardInput.fieldsValidationStatuses()
        
        let cardFieldsValidity = CardFieldsValidity(cardNumberValidationStatus: cardNumberValidationStatus, cardExpiryValidationStatus: cardExpiryValidationStatus, cardCVVValidationStatus: cardCVVValidationStatus, cardNameValidationStatus: cardNameValidationStatus)
        // Check that the card kit is already initilzed
        guard let _ = sharedNetworkManager.dataConfig.sdkSettings else {
            onErrorOccured("You have to call the initCardForm method first. This allows the card form to get the data needed to communicate with Tap's backend apis.",nil,cardFieldsValidity)
            return
        }
        // Check that the user entered a valid card data first
        guard let nonNullCard = currentTapCard,
              validation == .Valid,
              allFieldsAreValid(),
              let nonNullTokenizeCard:CreateTokenCard = try? .init(card: nonNullCard, address: nil) else {
            onErrorOccured("The user didn't enter a valid card data to save it. Please prompt the user to do so first.",nil,cardFieldsValidity)
            return
        }
        self.parentController = parentController
        // clear previous needed data
        sharedNetworkManager.dataConfig.cardVerify = nil
        // save to be needed data
        sharedNetworkManager.dataConfig.transactionCustomer = customer
        sharedNetworkManager.dataConfig.metadata = metadata
        sharedNetworkManager.dataConfig.enfroce3DS = enforce3DS
        sharedNetworkManager.dataConfig.onResponeSaveCardReady = { [weak self] card in
            self?.tapCardInputDelegate?.eventHappened(with: .SaveCardEnded)
            onResponeReady(card)
        }
        sharedNetworkManager.dataConfig.onErrorSaveCardOccured = { [weak self] error, card in
            self?.tapCardInputDelegate?.eventHappened(with: .SaveCardEnded)
            onErrorOccured(error, card,cardFieldsValidity)
        }
        tapCardInputDelegate?.eventHappened(with: .SaveCardStarted)
        // To save a card we need to tokenize it first
        sharedNetworkManager.callCardTokenAPI(cardTokenRequestModel: TapCreateTokenWithCardDataRequest(card: nonNullTokenizeCard),onResponeReady: { cardToken in
            // Now let us verify the card first
            sharedNetworkManager.handleTokenCardSave(with: cardToken) { [weak self] redirectionURL in
                self?.showWebView(with: redirectionURL)
            }
        }) { error in
            onErrorOccured(error,nil,cardFieldsValidity)
        }
    }
    
    
    
    // MARK:- Private functions
    
    private func allFieldsAreValid() -> Bool {
        
        let (cardNumberValidationStatus, cardExpiryValidationStatus, cardCVVValidationStatus, cardNameValidationStatus) = tapCardInput.fieldsValidationStatuses()
        
        return cardNumberValidationStatus && cardExpiryValidationStatus && cardCVVValidationStatus && cardNameValidationStatus
        
    }
    
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.contentView = setupXIB()
        /*if FirebaseApp.app() == nil {
            FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.current.path(forResource: "CardKitGoogle", ofType: "plist")!)!)
        }*/
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
        //guard showCardBrands else { return }
        // Setup the card brands bar view with the data source
        tapCardPhoneListView.setupView(with: tapCardPhoneListViewModel)
        
        // Set card brands datasource
        setupCardBrandsBarDataSource()
    }
    
    /**
     Handles the logic to display a UIWebview with a given url
     - Parameter with url: The url to be displayed
     */
    private func showWebView(with url:URL) {
        // make sure we have a parent controller to navigate with
        guard let nonNullParentController : UIViewController = parentController else {
            sharedNetworkManager.dataConfig.onErrorSaveCardOccured("To save a card, you need to tell us what is the parent UIViewController to start the 3ds process with",nil)
            return
        }
        
        self.tapCardInputDelegate?.eventHappened(with: .ThreeDSStarter)
        webViewModel = .init()
        webViewModel.delegate = self
        
        let tapViewController = TapWebViewController.init(nibName: "TapWebViewController", bundle: Bundle.current)
        self.threeDSDelegate = tapViewController
        
        DispatchQueue.main.async { [weak self] in
            nonNullParentController.present(tapViewController, animated: true) {
                tapViewController.stackView.addArrangedSubview((self?.webViewModel.attachedView)!)
                self?.webViewModel.load(with: url)
            }
        }
    }
    
    /// Will fetch the correct card brands from the loaded payment options based on the transaction currency
    private func setupCardBrandsBarDataSource() {
        // Dummy data source data for now
        dataSource = Array(sharedNetworkManager.dataConfig.paymentOptions?.toTapCardPhoneIconViewModel(supportsCurrency: sharedNetworkManager.dataConfig.transactionCurrency) ?? [])
        // Update the card input brands
        tapCardInput.allowedCardBrands = dataSource.map{ $0.associatedCardBrand.rawValue }
        
        DispatchQueue.main.async { [weak self] in
            self?.tapCardPhoneListView.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.1, options: []) {
                // Apply the new data source
                self?.tapCardPhoneListViewModel.dataSource = self?.dataSource ?? []
                self?.tapCardInput.cardsIconsUrls = self?.tapCardPhoneListViewModel.generateBrandsWithIcons()
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
        tapCardInput.setup(for: .InlineCardInput, showCardName: collectCardHolderName, showCardBrandIcon: showCardBrandIcon, allowedCardBrands: supportedBrands, cardsIconsUrls: tapCardPhoneListViewModel.generateBrandsWithIcons(), preloadCardHolderName: preloadCardHolderName, editCardName: editCardName)
        // Let us listen to the card input ui callbacks if needed
        tapCardInput.delegate = self
    }
     
    /// Handles logic needed to be done after changing the card data
    private func postCardDataChange() {
        // clear data upon needed
        if (currentTapCard?.tapCardNumber ?? "").isEmpty {
            sharedNetworkManager.resetBinData()
        }
        // let us call binlook up if possible
        sharedNetworkManager.callBinLookup(for: currentTapCard?.tapCardNumber,onResponeReady: { [weak self] _ in
            self?.handleBinLookUp()
        })
        
        tapCardInputDelegate?.eventHappened(with: canProcessCard() ? .CardReady : .CardNotReady)
    }
    
    /// Executes needed logic upon recieving a new look up response
    private func handleBinLookUp() {
        // Check if the card type is an allowed one
        guard let binResponse = sharedNetworkManager.dataConfig.tapBinLookUpResponse else { return }
        
        /*Analytics.logEvent("binResponse", parameters: [
            "binNumber": binResponse.binNumber,
            "scheme": "\(binResponse.scheme?.cardBrand.rawValue ?? 0)"
        ])*/
        
        if allowedCardType == .All || binResponse.cardType.cardType == allowedCardType {
            // Then it is allowed to proceed on with it :)
            // Set the favorite card brand as per the binlook up response
            CardValidator.favoriteCardBrand = fetchSupportedCardSchemes(for: sharedNetworkManager.dataConfig.tapBinLookUpResponse?.scheme?.cardBrand)
            /*let (brand,status) = tapCardInput.cardBrandWithStatus()
            if brand != cardBrand {
                cardBrand = brand
                validation = (status == .valid) ? .Valid : (status == .incomplete) ? .Incomplete : .Invalid
            }*/
            DispatchQueue.main.async { [weak self] in
                self?.tapCardInput.reValidateCardNumber()
            }
        }else{
            // Let us reset the card data and inform the delegate that the user tried entering a wrong card number
            self.tapCardInput.reset()
            CardValidator.favoriteCardBrand = nil
            self.tapCardInputDelegate?.errorOccured(with: .InvalidCardType, message: "Card entered is of type \(binResponse.cardType.cardType.description), allowed is: \(allowedCardType.description)")
        }
    }
    
    /// Computes  if the card data is fully entered or not
    private func canProcessCard() -> Bool {
        // Check that the user entered a valid card data first
        guard let nonNullCard = currentTapCard,
              validation == .Valid,
              allFieldsAreValid(),
              let _ : CreateTokenCard = try? .init(card: nonNullCard, address: nil) else {
            return false
        }
        
        return true
    }
    
    /// Handle the click on scan card by the user
    internal func showFullScanner() {
        // Make sure we have a UIViewcontroller to display the full screen scanner on
        guard let presentScannerInViewController = presentScannerInViewController else {
            return
        }

        // First grant the authorization to use the camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            if response {
                //access granted
                DispatchQueue.main.async {[weak self] in
                    self?.fullScanner = .init(delegate: self, uiCustomization: self?.tapScannerUICustomization ?? .init(), dataSource: self)
                    presentScannerInViewController.present((self?.fullScanner)!, animated: true)
                }
            }else {
                
            }
        }
    }
}

// MARK:- Card Forum UI delegate
*/
