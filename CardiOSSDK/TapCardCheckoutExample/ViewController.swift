//
//  ViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 21/03/2022.
//

import UIKit
import TapCardCheckOutKit
import CommonDataModelsKit_iOS

class ViewController: UIViewController, TapCardInputDelegate {
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
    
    @IBOutlet weak var tapCardForum: TapCardInputView!
    @IBOutlet weak var callbackTextView: UITextView!
    @IBOutlet weak var currencySegment: UISegmentedControl!
    
    var savedCustomer:TapCustomer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply the configurations
        configureCardInput()
        UIPasteboard.general.string = ""
        // Do any additional setup after loading the view.
    }

    
    /// Apply the configurations
    func configureCardInput() {
        
        tapCardForum.setupCardForm(locale: sharedConfigurationSharedManager.selectedLocale,
                                   collectCardHolderName: sharedConfigurationSharedManager.collectCardHolderName,
                                   showCardBrandsBar: sharedConfigurationSharedManager.showCardBrands,
                                   showCardScanner: sharedConfigurationSharedManager.showCardScanning,
                                   tapScannerUICustomization: .init(tapFullScreenScanBorderColor: sharedConfigurationSharedManager.scannerColor,
                                                                    blurCardScannerBackground:sharedConfigurationSharedManager.blurScanner),
                                   presentScannerInViewController: self,
                                   allowedCardTypes: sharedConfigurationSharedManager.allowedCardTypes,
                                   tapCardInputDelegate: self,
                                   preloadCardHolderName: (sharedConfigurationSharedManager.cardName == "None") ? "" : sharedConfigurationSharedManager.cardName,
                                   editCardName: sharedConfigurationSharedManager.editCardHolderName,
                                   showCardBrandIcon: sharedConfigurationSharedManager.showBrandIcon)
    }
    
    @IBAction func tokenizeCardClicked(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        tapCardForum.tokenizeCard { [weak self] token in
            self?.view.isUserInteractionEnabled = true
            print(token.card)
            self?.showAlert(title: "Tokenized", message: token.identifier)
        } onErrorOccured: { [weak self] error, cardFieldsValidity in
            print(error)
            self?.view.isUserInteractionEnabled = true
            self?.showAlert(title: "Error", message: "\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
        }
        
    }
    
    @IBAction func saveCardClicked(_ sender: Any) {
        let alert:UIAlertController = .init(title: "3DS", message: "Always force 3ds?", preferredStyle: .alert)
        alert.addAction(.init(title: "Yes", style: .destructive,handler: { [weak self] _ in
            self?.startSavingCard(enforce3DS: true)
        }))
        alert.addAction(.init(title: "No when possible", style: .default,handler: { [weak self] _ in
            self?.startSavingCard(enforce3DS: false)
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func  startSavingCard(enforce3DS:Bool = true) {
        self.view.isUserInteractionEnabled = false
        tapCardForum.saveCard(customer: savedCustomer!, parentController: self, metadata: [:]) { [weak self] card in
            print("HERE")
            self?.view.isUserInteractionEnabled = true
            UserDefaults.standard.set(try! PropertyListEncoder().encode(card.customer), forKey: "customerSevedKey")
            self?.showAlert(title: "Card saved", message: "\(card.card.lastFourDigits)\n\(card.identifier)")
        } onErrorOccured: { [weak self] error, card, cardFieldsValidity in
            self?.view.isUserInteractionEnabled = true
            if let error = error {
                self?.showAlert(title: "Error", message: "\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
            }else if let card = card,
                     let response = card.response,
                     let message = response.message,
                     let errorCode = response.code {
                self?.showAlert(title: "Card save status \(card.status.stringValue)", message: "Backend error message : \(message)\nWith code : \(errorCode)")
            }
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        showAlert(title: "Clicking on actions", message: "This will simulate the case where the card form is embedded inside the consumer's app screen and\n at a point of time, the consumer app asked the card kit to do this certain function.\nThe card kit will execute the required task and will feedback the consumer app, to handle it in its own way.\nHence, making it as flexible as possible.")
    }
    @IBAction func changeCurrency(_ sender: Any) {
        switch currencySegment.selectedSegmentIndex {
        case 0: tapCardForum.updateTransactionCurrenct(to: .KWD)
        case 1: tapCardForum.updateTransactionCurrenct(to: .EGP)
        case 2: tapCardForum.updateTransactionCurrenct(to: .SAR)
        default:
            break
        }
    }
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async { [weak self] in
            let alert:UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
    
    
    
    
}

