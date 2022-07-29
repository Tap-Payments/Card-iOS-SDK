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
        tapCardForum.tokenizeCard { [weak self] token in
            print(token.card)
            self?.showAlert(title: "Tokenized", message: token.identifier)
        } onErrorOccured: { [weak self] error in
            print(error)
            self?.showAlert(title: "Error", message: error.localizedDescription)
        }
        
    }
    
    @IBAction func saveCardClicked(_ sender: Any) {
        tapCardForum.saveCard(customer: try! .init(identifier: "cus_TS031720211012r4RM0403926"), parentController: self, metadata: [:]) { card in
            print("HERE")
        } onErrorOccured: { error, card in
            print(error ?? "")
        }

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

