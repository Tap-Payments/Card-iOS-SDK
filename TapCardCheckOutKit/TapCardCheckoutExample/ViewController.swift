//
//  ViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 21/03/2022.
//

import UIKit
import TapCardCheckOutKit

class ViewController: UIViewController {

    @IBOutlet weak var tapCardForum: TapCardInputView!
    
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
                                   showCardBrandsBar: sharedConfigurationSharedManager.showCardBrands)
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
    
    
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async { [weak self] in
            let alert:UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
}

