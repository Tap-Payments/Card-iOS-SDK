//
//  TapCardViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 06/10/2022.
//

import UIKit
import TapUIKit_iOS
import TapCardCheckOutKit
import CommonDataModelsKit_iOS


class TapCardViewController: UIViewController, TapCardInputDelegatee {
    
    
    func eventHappened(with event: CardKitEventType) {
        callbackTextView.text = "\(event.description)\n-------\n\(callbackTextView.text ?? "")"
    }
    
    
    func errorOccured(with error: CardKitErrorType, message:String) {
        var demoTitle:String = ""
        switch error {
        case .Network:
            demoTitle = "Network error"
        case .InvalidCardType:
            demoTitle = "Card type error"
        }
        showAlert(title: demoTitle, message: message)
    }
    
    
    @IBOutlet weak var tapCardView: TapCardView!
    @IBOutlet weak var callbackTextView: UITextView!
    @IBOutlet weak var currencySegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCardInput()
    }
    
    
    /// Apply the configurations
    func configureCardInput() {
        
        tapCardView.setupCardForm(locale: sharedConfigurationSharedManager.selectedLocale,
                                   collectCardHolderName: sharedConfigurationSharedManager.collectCardHolderName,
                                   showCardBrandsBar: sharedConfigurationSharedManager.showCardBrands,
                                   showCardScanner: sharedConfigurationSharedManager.showCardScanning,
                                   tapScannerUICustomization: .init(tapFullScreenScanBorderColor: sharedConfigurationSharedManager.scannerColor,
                                                                    blurCardScannerBackground:sharedConfigurationSharedManager.blurScanner),
                                   presentScannerInViewController: self,
                                   allowedCardTypes: sharedConfigurationSharedManager.allowedCardTypes,
                                   tapCardInputDelegate: self,
                                   preloadCardHolderName: (sharedConfigurationSharedManager.cardName == "None") ? "" : sharedConfigurationSharedManager.cardName,
                                   editCardName: sharedConfigurationSharedManager.editCardHolderName)
    }
    
    
    @IBAction func tokenizeCardClicked(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        tapCardView.tokenizeCard { [weak self] token in
            self?.view.isUserInteractionEnabled = true
            print(token.card)
            self?.showAlert(title: "Tokenized", message: token.identifier)
        } onErrorOccured: { [weak self] error, cardFieldsValidity in
            print(error)
            self?.view.isUserInteractionEnabled = true
            self?.showAlert(title: "Error", message: "\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
        }
        
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        showAlert(title: "Clicking on actions", message: "This will simulate the case where the card form is embedded inside the consumer's app screen and\n at a point of time, the consumer app asked the card kit to do this certain function.\nThe card kit will execute the required task and will feedback the consumer app, to handle it in its own way.\nHence, making it as flexible as possible.")
    }
    
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async { [weak self] in
            let alert:UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            self?.present(alert, animated: true)
        }
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
