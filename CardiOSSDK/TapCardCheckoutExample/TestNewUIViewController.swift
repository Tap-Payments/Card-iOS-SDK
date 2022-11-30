//
//  TestNewUIViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 07/10/2022.
//

import UIKit
import TapUIKit_iOS
import TapCardInputKit_iOS
import CommonDataModelsKit_iOS
import AVFoundation
import TapCardVlidatorKit_iOS

class TestNewUIViewController: UIViewController {
    
    var tapCardTelecomPaymentViewModel: TapCardTelecomPaymentViewModel = .init()
    let tapCardPhoneListViewModel:TapCardPhoneBarListViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBarViewModel()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(tapCardTelecomPaymentViewModel.attachedView)
    }
    
    
    
    func createTabBarViewModel() {
        var dataSource:[TapCardPhoneIconViewModel] = []
        dataSource.append(.init(associatedCardBrand: .visa, tapCardPhoneIconUrl: "https://img.icons8.com/color/2x/visa.png"))
        dataSource.append(.init(associatedCardBrand: .masterCard, tapCardPhoneIconUrl: "https://img.icons8.com/color/2x/mastercard.png"))
        dataSource.append(.init(associatedCardBrand: .americanExpress, tapCardPhoneIconUrl: "https://img.icons8.com/color/2x/amex.png"))
        
        tapCardPhoneListViewModel.dataSource = dataSource
        tapCardTelecomPaymentViewModel.collectCardName = false
        tapCardTelecomPaymentViewModel.saveCardType = .All
        tapCardTelecomPaymentViewModel.delegate = self
        tapCardTelecomPaymentViewModel.tapCardPhoneListViewModel = tapCardPhoneListViewModel
        tapCardTelecomPaymentViewModel.changeTapCountry(to: .init(nameAR: "الكويت", nameEN: "Kuwait", code: "965", phoneLength: 8))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension TestNewUIViewController:TapCardTelecomPaymentProtocol {
    func saveCardChanged(for saveCardType: SaveCardType, to enabled: Bool) {
        print("Save card changed to: \(enabled)")
    }
    
    func closeSavedCardClicked() {
        //tapGoPayChipsHorizontalListViewModel.deselectAll()
        //tapGatewayChipHorizontalListViewModel.deselectAll()
    }
    
    func shouldAllowChange(with cardNumber: String) -> Bool {
        return true
    }
    
    
    func showHint(with status: TapHintViewStatusEnum) {
        let hintViewModel:TapHintViewModel = .init(with: status)
        let hintView:TapHintView = hintViewModel.createHintView()
        //tapVerticalView.attach(hintView: hintView, to: TapCardTelecomPaymentView.self,with: true)
    }
    
    func hideHints() {
        //tapVerticalView.removeAllHintViews()
    }
    
    func cardDataChanged(tapCard: TapCard,cardStatusUI: CardInputUIStatus) {
        
    }
    
    func brandDetected(for cardBrand: CardBrand, with validation: CrardInputTextFieldStatusEnum,cardStatusUI: CardInputUIStatus) {
        //tapActionButtonViewModel.buttonStatus = (validation == .Valid) ? .ValidPayment : .InvalidPayment
        // Based on the detected brand type we decide the action button status
        if cardBrand.brandSegmentIdentifier == "telecom" {
            //handleTelecomPayment(for: cardBrand, with: validation)
        }else if cardBrand.brandSegmentIdentifier == "cards" {
            //handleCardPayment(for: cardBrand, with: validation)
        }
    }
    
    func scanCardClicked() {
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
