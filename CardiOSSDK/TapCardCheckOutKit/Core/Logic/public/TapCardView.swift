//
//  TapCardView.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 30/11/2022.
//

import UIKit
import SnapKit
import TapUIKit_iOS
import TapCardInputKit_iOS
import CommonDataModelsKit_iOS
import AVFoundation
import TapCardVlidatorKit_iOS
import LocalisationManagerKit_iOS
import TapCardScanner_iOS
import TapThemeManager2020
import TapThemeManager2020
import SwiftEntryKit

/// A protorocl to communicate with the three ds web view controller
internal protocol ThreeDSViewControllerDelegatee {
    /// Instruct the controller to dismiss itself
    func disimiss()
    
}


/// A protocol to listen to fired events form the card kit
@objc public protocol TapCardInputDelegatee {
    @objc func errorOccured(with error:CardKitErrorType, message:String)
    /**
     Be updated by listening to events fired from the card kit
     - Parameter with event: The event just fired
     */
    @objc func eventHappened(with event:CardKitEventType)
}

/// Represents the on the shelf card forum entry view
@IBDesignable @objcMembers public class TapCardView: UIView {
    /// Holds the last style theme applied
    private var lastUserInterfaceStyle:UIUserInterfaceStyle = .light
    /// The full scanner object that we will use to start scanning on demand
    private var fullScanner:TapFullScreenScannerViewController?// = TapFullScreenScannerViewController(dataSource: self)
    /// The ui customization to the full screen scanner borer color and to show a blut
    private var tapScannerUICustomization:TapFullScreenUICustomizer? = .init()
    /// A view to display to show the loading state
    @IBOutlet weak var loadingView: UIView!
    /// The actual card form view
    @IBOutlet weak var cardView: TapCardTelecomPaymentView!
    /// Represents the main holding view
    @IBOutlet var contentView: UIView!
    /// The webview model handler
    private var webViewModel:TapWebViewModel = .init()
    /// Holds the latest detected card brand
    internal var cardBrand: CardBrand?
    /// Defines the attributes/configurations when displaying the 3DS web page
    internal var threeDSConfiguration:ThreeDSConfiguration = .init()
    /// Holds the latest validation status for the entered card data
    internal var validation: CrardInputTextFieldStatusEnum = .Invalid {
        didSet{
            selectCorrectBrand()
        }
    }
    /// Tells if we need to show the loading state in the card view or not
    internal var showLoadingState:Bool = true
    /// Represents the view model for handling the card forum
    internal let tapCardTelecomPaymentViewModel: TapCardTelecomPaymentViewModel = .init()
    /// Represents the view model for handling the card brands bar
    internal let tapCardPhoneListViewModel:TapCardPhoneBarListViewModel = .init()
    /// The parent controller will be used to present the web view whenever a 3DS is required to save the card details
    private var parentController:UIViewController?
    
    /// A protorocl to communicate with the three ds web view controller
    internal var threeDSDelegate: ThreeDSViewControllerDelegatee?
    /// A delegate listens for needed actions and callbacks
    internal var tapCardInputDelegate:TapCardInputDelegatee?
    /// Represents the data source for the card brands bar
    var dataSource:[TapCardPhoneIconViewModel] = []
    /// Holds the latest card info provided by the user
    internal var currentTapCard:TapCard? {
        didSet{
            postCardDataChange()
        }
    }
    // Mark:- Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
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
    
    /// Indicates whether ot not the card form will show the card brands bar
    private var showCardBrands:Bool = false {
        didSet {
            //setupCardBrandsBar()
        }
    }
    
    
    /// Indicates whether ot not the card scanner. Default is false
    private var showCardScanner:Bool = false
    
    /// The UIViewController that will display the scanner into
    private var presentScannerInViewController:UIViewController?
    
    /// Decides which cards shall we accept
    private var allowedCardType:cardTypes = .All
    
    /// A preloading value for the card holder name if needed
    internal var preloadCardHolderName:String = ""
    /// Indicates whether or not the user can edit the card holder name field. Default is true
    internal var editCardName:Bool = true
    
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
     - Parameter threeDSConfiguration: Defines the attributes/configurations when displaying the 3DS web page
     - Parameter showLoadingState: Tells if we need to show the loading state in the card view or not. Default is true
     */
    
    @objc public func setupCardForm(locale:String = "en", collectCardHolderName:Bool = false, showCardBrandsBar:Bool = false, showCardScanner:Bool = false, tapScannerUICustomization:TapFullScreenUICustomizer? = .init() , transactionCurrency:TapCurrencyCode = .KWD, presentScannerInViewController:UIViewController?, allowedCardTypes:cardTypes = .All, tapCardInputDelegate:TapCardInputDelegatee? = nil, preloadCardHolderName:String = "", editCardName:Bool = true, threeDSConfiguration:ThreeDSConfiguration = .init(), showLoadingState:Bool = true) {
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
        // A delegate listens for needed actions and callbacks
        self.tapCardInputDelegate = tapCardInputDelegate
        // Set the attributes/configurations when displaying the 3DS web page
        self.threeDSConfiguration = threeDSConfiguration
        // Tells if we need to show the loading state in the card view or not. Default is true
        self.showLoadingState = showLoadingState
        // Init the card brands bar
        setupCardBrandsBarDataSource()
        // Adjust the UI now
        createTabBarViewModel()
        addActualCardInputView()
    }
    
    
    /**
     Handles tokenizing the current card data.
     - Parameter onResponeReady: A callback to listen when a token is successfully generated
     - Parameter onErrorOccured: A callback to listen when tokenization fails with error message and the validity of all the card fields for your own interest
     */
    @objc public func tokenizeCard(onResponeReady: @escaping (CommonDataModelsKit_iOS.Token) -> () = {_ in}, onErrorOccured: @escaping(Error,CardFieldsValidity)->() = {_,_  in}) {
        // get the validity of all fields
        let (cardNumberValidationStatus, cardExpiryValidationStatus, cardCVVValidationStatus, cardNameValidationStatus) = cardView.cardInputView.fieldsValidationStatuses()
        
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
        changeSelfEnablement(to: false)
        sharedNetworkManager.callCardTokenAPI(cardTokenRequestModel: TapCreateTokenWithCardDataRequest(card: nonNullTokenizeCard)) { [weak self] token in
            self?.changeSelfEnablement(to: true)
            self?.tapCardInputDelegate?.eventHappened(with: .TokenizeEnded)
            onResponeReady(token)
        } onErrorOccured: { [weak self] error in
            self?.changeSelfEnablement(to: true)
            self?.tapCardInputDelegate?.eventHappened(with: .TokenizeEnded)
            onErrorOccured(error, cardFieldsValidity)
        }
        
    }
    
    /// Enable/Disable self based on input
    /// - Parameter to: True to enable self or false otherwise
    private func changeSelfEnablement(to:Bool) {
        isUserInteractionEnabled = to
        // Only if it is allowed to show the loading state we will display it
        guard showLoadingState else { return }
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let targetFrame = cardView.stackView.frame
        loadingView.snp.remakeConstraints { make in
            make.leading.equalTo(cardView.snp_leadingMargin).offset(targetFrame.origin.x)
            make.trailing.equalTo(cardView.snp_trailingMargin).offset(-targetFrame.origin.x)
            make.top.equalTo(targetFrame.origin.y)
            make.width.equalTo(targetFrame.width)
            make.height.equalTo(targetFrame.height)
        }
        loadingView.layoutIfNeeded()
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                self?.loadingView.alpha = to ? 0 : 1
            }
        }
    }
    
    private func centeralPopUpAttributes() -> EKAttributes {
        var attributes: EKAttributes
        let displayMode:EKAttributes.DisplayMode = .inferred
        
        attributes = .centerFloat
        attributes.displayMode = displayMode
        attributes.displayDuration = .infinity
        attributes.screenBackground = .visualEffect(style: .init(style:threeDSConfiguration.backgroundBlurStyle))
        attributes.entryBackground = .color(color: .clear)
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        switch threeDSConfiguration.threeDsAnimationType {
            case .ZoomIn:
            attributes.entranceAnimation = .init(
                scale: .init(from: 0, to: 1, duration: threeDSConfiguration.animationDuration, spring: .init(damping: 1, initialVelocity: 0))
            )
        case.BottomTransition:
            attributes.entranceAnimation = .init(
                translate: .init(duration: threeDSConfiguration.animationDuration)
            )
        }
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.35)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: threeDSConfiguration.animationDuration)
                //scale: .init(from: 0, to: 1, duration: 1.5)
            )
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 6
            )
        )
        attributes.positionConstraints.size = .init(
            width: .fill,
            height: .ratio(value: 0.85)
        )
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .overridden
        attributes.statusBar = .dark
        return attributes
        
    }
    
    
    /**
     Call this method to change the currency at run time. Please note that this will reset the card data and change the visible card brands.
     - Parameter to currency: The new transaction currency
     */
    @objc public func updateTransactionCurrenct(to currency:TapCurrencyCode) {
        // set the new currency
        sharedNetworkManager.dataConfig.transactionCurrency = currency
        // reset card form data
        cardView.cardInputView.reset()
        // reload the bar view
        setupCardBrandsBarDataSource()
    }
    
    /**
     Handles saving the current card data.
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
        
        
        let (cardNumberValidationStatus, cardExpiryValidationStatus, cardCVVValidationStatus, cardNameValidationStatus) = cardView.cardInputView.fieldsValidationStatuses()
        
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
            self?.changeSelfEnablement(to: true)
            self?.tapCardInputDelegate?.eventHappened(with: .SaveCardEnded)
            onResponeReady(card)
        }
        sharedNetworkManager.dataConfig.onErrorSaveCardOccured = { [weak self] error, card in
            self?.changeSelfEnablement(to: true)
            self?.tapCardInputDelegate?.eventHappened(with: .SaveCardEnded)
            onErrorOccured(error, card,cardFieldsValidity)
        }
        tapCardInputDelegate?.eventHappened(with: .SaveCardStarted)
        //showWebView(with: URL(string: "https://www.google.com")!)
        changeSelfEnablement(to: false)
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
    
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.contentView = setupXIB()
        applyTheme()
    }
    
    /// Fetches the card forum view from the view model and add it to the parent view
    private func addActualCardInputView() {
        // assign the view models
        tapCardTelecomPaymentViewModel.saveCardType = .Merchant
        cardView.viewModel = tapCardTelecomPaymentViewModel
        cardView.tapCardPhoneListViewModel = tapCardPhoneListViewModel
    }
    
    /// Creates the view models for the card brands bar and the card forum views
    private func createTabBarViewModel() {
        // let us setup the card brands bar sources
        setupCardBrandsBarDataSource()
        // pass the configurations passed from the caller app
        tapCardTelecomPaymentViewModel.collectCardName = collectCardHolderName
        tapCardTelecomPaymentViewModel.saveCardType = .None
        tapCardTelecomPaymentViewModel.showCardBrandsBar = showCardBrands
        tapCardTelecomPaymentViewModel.showScanner = showCardScanner
        tapCardTelecomPaymentViewModel.preloadCardHolderName = preloadCardHolderName
        // Assign the delegates and the view models
        tapCardTelecomPaymentViewModel.delegate = self
        tapCardTelecomPaymentViewModel.tapCardPhoneListViewModel = tapCardPhoneListViewModel
        tapCardTelecomPaymentViewModel.changeTapCountry(to: .init(nameAR: "الكويت", nameEN: "Kuwait", code: "965", phoneLength: 8))
    }
    
    
    /// Will fetch the correct card brands from the loaded payment options based on the transaction currency
    private func setupCardBrandsBarDataSource() {
        // Get data from the Network Manager
        dataSource = Array(sharedNetworkManager.dataConfig.paymentOptions?.toTapCardPhoneIconViewModel(supportsCurrency: sharedNetworkManager.dataConfig.transactionCurrency) ?? [])
        // Update the card input brands
        cardView.cardInputView.allowedCardBrands = dataSource.map{ $0.associatedCardBrand.rawValue }
        // Apply the new data source
        tapCardPhoneListViewModel.dataSource = dataSource
        // Auto select the card section
        tapCardPhoneListViewModel.select(segment: "cards")
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
                self?.cardView.cardInputView.reValidateCardNumber()
            }
        }else{
            // Let us reset the card data and inform the delegate that the user tried entering a wrong card number
            self.cardView.cardInputView.reset()
            CardValidator.favoriteCardBrand = nil
            self.tapCardInputDelegate?.errorOccured(with: .InvalidCardType, message: "Card entered is of type \(binResponse.cardType.cardType.description), allowed is: \(allowedCardType.description)")
        }
    }
    
    
    /// Computes  if the card data is fully entered or not
    @objc public func canProcessCard() -> Bool {
        // Check that the user entered a valid card data first
        guard let nonNullCard = currentTapCard,
              validation == .Valid,
              allFieldsAreValid(),
              let _ : CreateTokenCard = try? .init(card: nonNullCard, address: nil) else {
            return false
        }
        
        return true
    }
    
    
    /// Checks if all fields inside the card forum are valid or not
    private func allFieldsAreValid() -> Bool {
        
        let (cardNumberValidationStatus, cardExpiryValidationStatus, cardCVVValidationStatus, cardNameValidationStatus) = cardView.cardInputView.fieldsValidationStatuses()
        
        return cardNumberValidationStatus && cardExpiryValidationStatus && cardCVVValidationStatus && cardNameValidationStatus
        
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
        webViewModel.shouldShowHeaderView = threeDSConfiguration.showHeaderView
        webViewModel.delegate = self
        
        let tapViewController = TapWebViewController.init(nibName: "TapWebViewController", bundle: Bundle.current)
        self.threeDSDelegate = tapViewController
        tapViewController.webViewModel = webViewModel
        tapViewController.url = url
        let attributes = centeralPopUpAttributes()
        
        DispatchQueue.main.async { [weak self] in
            /*tapViewController.stackView.addArrangedSubview((self?.webViewModel.attachedView)!)
            self?.webViewModel.load(with: url)*/
            
            SwiftEntryKit.display(entry: tapViewController, using: attributes)
        }
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

extension TapCardView:TapCardTelecomPaymentProtocol {
    public func saveCardChanged(for saveCardType: SaveCardType, to enabled: Bool) {
        print("Save card changed to: \(enabled)")
        tapCardInputDelegate?.eventHappened(with: enabled ? .SaveCardEnabled : .SaveCardDisabled)
    }
    
    public func closeSavedCardClicked() {
        //tapGoPayChipsHorizontalListViewModel.deselectAll()
        //tapGatewayChipHorizontalListViewModel.deselectAll()
    }
    
    public func shouldAllowChange(with cardNumber: String) -> Bool {
        return true
    }
    
    
    public func showHint(with status: TapHintViewStatusEnum) {
        let hintViewModel:TapHintViewModel = .init(with: status)
        let hintView:TapHintView = hintViewModel.createHintView()
        //tapVerticalView.attach(hintView: hintView, to: TapCardTelecomPaymentView.self,with: true)
    }
    
    public func hideHints() {
        //tapVerticalView.removeAllHintViews()
    }
    
    public func cardDataChanged(tapCard: TapCard,cardStatusUI: CardInputUIStatus) {
        currentTapCard = tapCard
    }
    
    public func brandDetected(for cardBrand: CardBrand, with validation: CrardInputTextFieldStatusEnum,cardStatusUI: CardInputUIStatus) {
        //tapActionButtonViewModel.buttonStatus = (validation == .Valid) ? .ValidPayment : .InvalidPayment
        // Based on the detected brand type we decide the action button status
        if cardBrand.brandSegmentIdentifier == "telecom" {
            //handleTelecomPayment(for: cardBrand, with: validation)
        }else if cardBrand.brandSegmentIdentifier == "cards" {
            //handleCardPayment(for: cardBrand, with: validation)
            self.cardBrand = cardBrand
            self.validation = validation
        }
    }
    
    public func scanCardClicked() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            if response {
                //access granted
                DispatchQueue.main.asyncAfter(deadline: .now()) {[weak self] in
                    self?.cardView.cardInputView.reset()
                    CardValidator.favoriteCardBrand = nil
                    self?.showFullScanner()
                }
            }
        }
    }
}




extension TapCardView {
    /// Consolidated one point to apply all needed theme methods
    public func applyTheme() {
        matchThemeAttributes()
    }
    
    /// Match the UI attributes with the correct theming entries
    private func matchThemeAttributes() {
        
        // background color
        self.tap_theme_backgroundColor = ThemeUIColorSelector.init(keyPath: "horizontalList.backgroundColor")
        // loading view background color
        loadingView.tap_theme_backgroundColor = ThemeUIColorSelector.init(keyPath: "inlineCard.commonAttributes.backgroundColor")
    }
    
    /// Listen to light/dark mde changes and apply the correct theme based on the new style
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        TapThemeManager.changeThemeDisplay(for: self.traitCollection.userInterfaceStyle)
        
        guard lastUserInterfaceStyle != self.traitCollection.userInterfaceStyle else {
            return
        }
        lastUserInterfaceStyle = self.traitCollection.userInterfaceStyle
        applyTheme()
    }
}
    
