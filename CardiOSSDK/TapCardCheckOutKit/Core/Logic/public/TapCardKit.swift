//
//  TapCardKit.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 07/10/2022.
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
import SnapKit

@objc public class TapCardKit: UIView {
    /*/// Represents the main holding view
    @IBOutlet var contentView: UIView!
    
    
    /// Represents the view model for handling the card brands bar
    internal let tapCardPhoneListViewModel:TapCardPhoneBarListViewModel = .init()
    /// Represents the data source for the card brands bar
    internal var dataSource:[TapCardPhoneIconViewModel] = []
    /// Represents a view model to control the wrapper view that does the needed connections between cardtelecomBar, card input and telecom input
    internal var tapCardTelecomPaymentViewModel: TapCardTelecomPaymentViewModel = .init()
    
    /// A reference to the localisation manager
    internal var locale:String = "en" {
        didSet {
            TapLocalisationManager.shared.localisationLocale = locale
        }
    }
    
    /// The ui customization to the full screen scanner borer color and to show a blut
    private var tapScannerUICustomization:TapFullScreenUICustomizer? = .init()
    
    /// The UIViewController that will display the scanner into
    private var presentScannerInViewController:UIViewController?
    
    /// Decides which cards shall we accept
    private var allowedCardType:cardTypes = .All
    
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
        self.tapCardTelecomPaymentViewModel.collectCardName = collectCardHolderName
        // Set the card bar ability
        //self.tapCardTelecomPaymentViewModel.showCardBrands = showCardBrandsBar
        // The ui customization to the full screen scanner borer color and to show a blur
        self.tapScannerUICustomization = tapScannerUICustomization
        // Set the needed currency
        sharedNetworkManager.dataConfig.transactionCurrency = transactionCurrency
        // Indicates whether ot not the card scanner. Default is false
        //self.tapCardTelecomPaymentViewModel.showCardScanner = showCardScanner
        // The UIViewController that will display the scanner into
        self.presentScannerInViewController = presentScannerInViewController
        // Decides which cards shall we accept
        self.allowedCardType = allowedCardTypes
        // A delegate listens for needed actions and callbacks
        //self.tapCardInputDelegate = tapCardInputDelegate
        /// Set the preloading value for card name
        //self.preloadCardHolderName = preloadCardHolderName
        /// Set the editibility for the card name field
        //self.editCardName = editCardName
        /// deines whether to show the detected brand icon besides the card number instead of the placeholdder
        //self.showCardBrandIcon = showCardBrandIcon
        // Adjust the UI now
        initUI()
        // Init the card brands bar
        setupCardBrandsBar()
    }
    
    //MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.contentView = setupXIB()
    }
*/
}
