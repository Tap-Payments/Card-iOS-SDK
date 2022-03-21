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

/// Represents the on the shelf card forum entry view
public class TapCardInputView : UIView {
    /// Represents the main holding view
    @IBOutlet var contentView: UIView!
    /// Represents the UI part of the embedded card entry forum
    @IBOutlet weak var tapCardInput: TapCardInput!
    
    /// Holds the latest card info provided by the user
    private var currentTapCard:TapCard?
    
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
    
    ///  Initiates the card input forum by adjusting the UI and defining the card brands
    public func configureCardInput() {
        // Set the default
        TapThemeManager.setDefaultTapTheme()
        // As per the requirement, the card forum kit will not care about allowed card brands,
        // Hence we declare it to accept all cards.
        tapCardInput.setup(for: .InlineCardInput, allowedCardBrands: CardBrand.allCases.map{ $0.rawValue })
        // Let us listen to the card input ui callbacks if needed
        tapCardInput.delegate = self
    }
    
    // MARK:- Private functions
    
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.contentView = setupXIB()
        initUI()
    }
    
    /// Does the needed pre logic to shape the card input UI forum
    private func initUI() {
        tapCardInput.translatesAutoresizingMaskIntoConstraints = false
        tapCardInput.showSaveCardOption = false
        tapCardInput.showScanningOption = false
        configureCardInput()
    }
}

extension TapCardInputView : TapCardInputProtocol {
    public func cardDataChanged(tapCard: TapCard) {
        currentTapCard = tapCard
    }
    
    public func brandDetected(for cardBrand: CardBrand, with validation: CrardInputTextFieldStatusEnum) {
        
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
