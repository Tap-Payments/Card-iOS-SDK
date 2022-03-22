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
import MOLH

/// Represents the on the shelf card forum entry view
@objc public class TapCardInputView : UIView {
    /// Represents the main holding view
    @IBOutlet var contentView: UIView!
    /// Represents the UI part of the embedded card entry forum
    @IBOutlet weak var tapCardInput: TapCardInput!
    
    /// Holds the latest card info provided by the user
    private var currentTapCard:TapCard?
    
    /// Holds the latest detected card brand
    private var cardBrand: CardBrand?
    /// Holds the latest validation status for the entered card data
    private var validation: CrardInputTextFieldStatusEnum = .Invalid
    /// A reference to the localisation manager
    private var sharedLocalisationManager = TapLocalisationManager.shared
    
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
        guard let nonNullConfiguration = TapCardForumConfiguration.shared.dataConfig else {
            // This means the app didn't populate reuired data to talk to backend correctly before loading the view. Hence, we hide it
            DispatchQueue.main.async { [weak self] in
                self?.tapCardInput.isHidden = true
                print("Tap Card Forum error : Please populate data in TapCardForumConfiguration.shared first before showing the view")
            }
            return
        }
        // Store the configueation data for further access
        NetworkManager.shared.dataConfig = nonNullConfiguration
        // Infotm the network manager to init itself from the init api
        NetworkManager.shared.initialiseSDKFromAPI()
    }
    
    
    ///  Initiates the card input forum by adjusting the UI and defining the card brands
    private func configureCardInputUI() {
        // As per the requirement, the card forum kit will not care about allowed card brands,
        // Hence we declare it to accept all cards.
        tapCardInput.setup(for: .InlineCardInput, allowedCardBrands: CardBrand.allCases.map{ $0.rawValue })
        // Let us listen to the card input ui callbacks if needed
        tapCardInput.delegate = self
        // Call init api to be ready for token api on demand
        initCardForm()
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
