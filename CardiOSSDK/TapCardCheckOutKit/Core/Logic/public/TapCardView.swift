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

@IBDesignable @objcMembers public class TapCardView: UIView {

    @IBOutlet weak var cardView: TapCardTelecomPaymentView!
    @IBOutlet var contentView: UIView!
    internal let tapCardTelecomPaymentViewModel: TapCardTelecomPaymentViewModel = .init()
    internal let tapCardPhoneListViewModel:TapCardPhoneBarListViewModel = .init()
    
    
    // Mark:- Init methods
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
        createTabBarViewModel()
        addActualCardInputView()
    }
    
    
    private func addActualCardInputView() {
        cardView.viewModel = tapCardTelecomPaymentViewModel
        cardView.tapCardPhoneListViewModel = tapCardPhoneListViewModel
    }
    
    private func createTabBarViewModel() {
        var dataSource:[TapCardPhoneIconViewModel] = []
        dataSource.append(.init(associatedCardBrand: .visa, tapCardPhoneIconUrl: "https://img.icons8.com/color/2x/visa.png"))
        dataSource.append(.init(associatedCardBrand: .masterCard, tapCardPhoneIconUrl: "https://img.icons8.com/color/2x/mastercard.png"))
        dataSource.append(.init(associatedCardBrand: .americanExpress, tapCardPhoneIconUrl: "https://img.icons8.com/color/2x/amex.png"))
        
        tapCardPhoneListViewModel.dataSource = dataSource
        tapCardTelecomPaymentViewModel.collectCardName = false
        tapCardTelecomPaymentViewModel.saveCardType = .None
        tapCardTelecomPaymentViewModel.delegate = self
        tapCardTelecomPaymentViewModel.tapCardPhoneListViewModel = tapCardPhoneListViewModel
        tapCardTelecomPaymentViewModel.changeTapCountry(to: .init(nameAR: "الكويت", nameEN: "Kuwait", code: "965", phoneLength: 8))
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
        
    }
    
    public func brandDetected(for cardBrand: CardBrand, with validation: CrardInputTextFieldStatusEnum,cardStatusUI: CardInputUIStatus) {
        //tapActionButtonViewModel.buttonStatus = (validation == .Valid) ? .ValidPayment : .InvalidPayment
        // Based on the detected brand type we decide the action button status
        if cardBrand.brandSegmentIdentifier == "telecom" {
            //handleTelecomPayment(for: cardBrand, with: validation)
        }else if cardBrand.brandSegmentIdentifier == "cards" {
            //handleCardPayment(for: cardBrand, with: validation)
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
