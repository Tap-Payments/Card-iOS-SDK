//
//  ViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 21/03/2022.
//

import UIKit
import TapCardCheckOutKit

class ViewController: UIViewController, TapCardInputDelegate {
    
    func errorOccured(with error: CardKitErrorType) {
        showAlert(title: "Wrong card type", message: "Tap informed us, you tried with a non allowed card type. Please only \(sharedConfigurationSharedManager.allowedCardTypes.description) cards")
    }
    
    @IBOutlet weak var tapCardForum: TapCardInputView!
    @IBOutlet weak var currencySegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply the configurations
        configureCardInput()
        // Do any additional setup after loading the view.
    }

    
    /// Apply the configurations
    func configureCardInput() {
        
        tapCardForum.setupCardForm(locale: sharedConfigurationSharedManager.selectedLocale,
                                   collectCardHolderName: sharedConfigurationSharedManager.collectCardHolderName,
                                   showCardBrandsBar: sharedConfigurationSharedManager.showCardBrands,
                                   showCardScanner: sharedConfigurationSharedManager.showCardScanning,
                                   tapScannerUICustomization: .init(blurCardScannerBackground:false),
                                   presentScannerInViewController: self,
                                   allowedCardTypes: sharedConfigurationSharedManager.allowedCardTypes,
                                   tapCardInputDelegate: self)
    }
    
    @IBAction func tokenizeCardClicked(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        tapCardForum.tokenizeCard { [weak self] token in
            self?.view.isUserInteractionEnabled = true
            print(token.card)
            self?.showAlert(title: "Tokenized", message: token.identifier)
        } onErrorOccured: { [weak self] error in
            print(error)
            self?.view.isUserInteractionEnabled = true
            self?.showAlert(title: "Error", message: error.localizedDescription)
        }
        
    }
    
    @IBAction func saveCardClicked(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        tapCardForum.saveCard(customer: try! .init(emailAddress: .init(emailAddressString: "test@gmailtap.com"), phoneNumber: .init(isdNumber: "20", phoneNumber: "01009366361"), firstName: "OSAMA", middleName: "AHMED", lastName: "HELMY"), parentController: self, metadata: [:]) { [weak self] card in
            print("HERE")
            self?.view.isUserInteractionEnabled = true
            self?.showAlert(title: "Card saved", message: "\(card.card.lastFourDigits)\n\(card.identifier)")
        } onErrorOccured: { [weak self] error, card in
            self?.view.isUserInteractionEnabled = true
            if let error = error {
                self?.showAlert(title: "Failed", message: error.localizedDescription)
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

