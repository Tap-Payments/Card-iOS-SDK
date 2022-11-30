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


@IBDesignable @objcMembers public class TapCardView: UIView {

    @IBOutlet weak var cardView: TapCardTelecomPaymentView!
    @IBOutlet var contentView: UIView!
    /// Holds the latest detected card brand
    internal var cardBrand: CardBrand?
    /// Holds the latest validation status for the entered card data
    internal var validation: CrardInputTextFieldStatusEnum = .Invalid {
        didSet{
            selectCorrectBrand()
        }
    }
    internal let tapCardTelecomPaymentViewModel: TapCardTelecomPaymentViewModel = .init()
    internal let tapCardPhoneListViewModel:TapCardPhoneBarListViewModel = .init()
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
    
    @objc public func setupCardForm(locale:String = "en", collectCardHolderName:Bool = false, showCardBrandsBar:Bool = false, showCardScanner:Bool = false, tapScannerUICustomization:TapFullScreenUICustomizer? = .init() , transactionCurrency:TapCurrencyCode = .KWD, presentScannerInViewController:UIViewController?, allowedCardTypes:cardTypes = .All, tapCardInputDelegate:TapCardInputDelegatee? = nil, preloadCardHolderName:String = "", editCardName:Bool = true) {
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
    @objc public func tokenizeCard(onResponeReady: @escaping (Token) -> () = {_ in}, onErrorOccured: @escaping(Error,CardFieldsValidity)->() = {_,_  in}) {
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
        sharedNetworkManager.callCardTokenAPI(cardTokenRequestModel: TapCreateTokenWithCardDataRequest(card: nonNullTokenizeCard)) { [weak self] token in
            self?.tapCardInputDelegate?.eventHappened(with: .TokenizeEnded)
            onResponeReady(token)
        } onErrorOccured: { [weak self] error in
            self?.tapCardInputDelegate?.eventHappened(with: .TokenizeEnded)
            onErrorOccured(error, cardFieldsValidity)
        }
        
    }
    
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.contentView = setupXIB()
    }
    
    
    private func addActualCardInputView() {
        tapCardTelecomPaymentViewModel.collectCardName = self.collectCardHolderName
        
        tapCardTelecomPaymentViewModel.saveCardType = .Merchant
        
        cardView.viewModel = tapCardTelecomPaymentViewModel
        cardView.tapCardPhoneListViewModel = tapCardPhoneListViewModel
    }
    
    private func createTabBarViewModel() {
        setupCardBrandsBarDataSource()
        tapCardTelecomPaymentViewModel.collectCardName = collectCardHolderName
        tapCardTelecomPaymentViewModel.saveCardType = .None
        tapCardTelecomPaymentViewModel.showCardBrandsBar = showCardBrands
        tapCardTelecomPaymentViewModel.showScanner = showCardScanner
        tapCardTelecomPaymentViewModel.preloadCardHolderName = preloadCardHolderName
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
    
    
    private func allFieldsAreValid() -> Bool {
        
        let (cardNumberValidationStatus, cardExpiryValidationStatus, cardCVVValidationStatus, cardNameValidationStatus) = cardView.cardInputView.fieldsValidationStatuses()
        
        return cardNumberValidationStatus && cardExpiryValidationStatus && cardCVVValidationStatus && cardNameValidationStatus
        
    }
    
    
}

extension TapCardView:TapCardTelecomPaymentProtocol {
    public func saveCardChanged(for saveCardType: SaveCardType, to enabled: Bool) {
        print("Save card changed to: \(enabled)")
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
                    //self?.showScanner()
                }
            }
        }
    }
}
