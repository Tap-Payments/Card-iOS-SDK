//
//  CardWebSDKExample.swift
//  TapCardCheckoutExample
//
//  Created by MahmoudShaabanAllam on 06/09/2023.
//

import UIKit
import TapCardCheckOutKit

class TapCardSDKExample: UIViewController {
    @IBOutlet weak var tapCardView: TapCardView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var eventsTextView: UITextView!
    
    var config: TapCardConfiguration = .init(publicKey: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
                                             merchant: Merchant(id: ""),
                                             transaction: Transaction(amount: 1, currency: "SAR"),
                                             customer: Customer(id: nil, name: [.init(lang: "en", first: "Tap", last: "Payments", middle: "")], nameOnCard: "Tap Payments", contact: .init(email: "tappayments@tap.company", phone: .init(countryCode: "+965", number: "88888888"))),
                                             acceptance: Acceptance(supportedBrands: ["AMEX","VISA","MASTERCARD","OMANNET","MADA"], supportedCards: ["CREDIT","DEBIT"]),
                                             fields: Fields(cardHolder: true),
                                             addons: Addons(displayPaymentBrands: true, loader: true, saveCard: false),
                                             interface: Interface(locale: "en", theme: "light", edges: "curved", direction: "ltr"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapCardSDK()
        button.isEnabled = false
        /*tapCardView?.initWebCardSDK(configString: """
{
    "publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7",
    "merchant": {
        "id": ""
    },
    "transaction": {
        "amount": 1,
        "currency": "SAR"
    },
    "customer": {
        "id": "",
        "name": [
            {
                "lang": "en",
                "first": "Ahmed",
                "last": "Sharkawy",
                "middle": "Mohamed"
            }
        ],
        "nameOnCard": "Ahmed Sharkawy",
        "editable": true,
        "contact": {
            "email": "ahmed@gmail.com",
            "phone": {
                "countryCode": "20",
                "number": "1000000000"
            }
        }
    },
    "acceptance": {
        "supportedBrands": [
            "AMEX",
            "VISA",
            "MASTERCARD",
            "MADA"
        ],
        "supportedCards": [
            "CREDIT",
            "DEBIT"
        ]
    },
    "fields": {
        "cardHolder": true
    },
    "addons": {
        "displayPaymentBrands": true,
        "loader": true,
        "saveCard": true
    },
    "interface": {
        "locale": "en",
        "theme": "light",
        "edges": "curved",
        "direction": "ltr"
    }
}
""")
        */
    }

    func setupTapCardSDK() {
        tapCardView.initTapCardSDK(config: self.config, delegate: self, presentScannerIn: self)
    }
    
    @IBAction func generateToken(_ sender: Any) {
        tapCardView?.generateTapToken()
    }

    @IBAction func configClicked(_ sender: Any) {
        let configCtrl:CardSettingsViewController = storyboard?.instantiateViewController(withIdentifier: "CardSettingsViewController") as! CardSettingsViewController
        configCtrl.config = config
        configCtrl.delegate = self
        //present(configCtrl, animated: true)
        tapCardView?.scanCard()
        
    }
    
    /*func setConfig(config: CardWebSDKConfig) {
        self.config = config
    }*/
}


extension TapCardSDKExample: CardSettingsViewControllerDelegate {
    
    func updateConfig(config: TapCardConfiguration) {
        self.config = config
        setupTapCardSDK()
    }
    
}

extension TapCardSDKExample: TapCardViewDelegate {
    func onHeightChange(height: Double) {
        //print("CardWebSDKExample onHeightChange \(height)")
    }
    
    func onBinIdentification(data: String) {
        //print("CardWebSDKExample onBinIdentification \(data)")
        eventsTextView.text = "\n\n========\n\nonBinIdentification \(data)\(eventsTextView.text ?? "")"
    }
    
    func onValidInput(valid: Bool) {
        print("CardWebSDKExample onValidInput \(valid)")

    }
    
    func onInvalidInput(invalid: Bool) {
        //print("CardWebSDKExample onInvalidInput \(invalid)")
        eventsTextView.text = "\n\n========\n\nonInvalidInput \(invalid)\(eventsTextView.text ?? "")"
        button.isEnabled = !invalid
    }
    
    func onSuccess(data: String) {
        //print("CardWebSDKExample onSuccess \(data)")
        eventsTextView.text = "\n\n========\n\nonSuccess \(data)\(eventsTextView.text ?? "")"

    }
    
    func onError(data: String) {
        //print("CardWebSDKExample onError \(data)")
        eventsTextView.text = "\n\n========\n\nonError \(data)\(eventsTextView.text ?? "")"
    }
    
    func onReady(){
        //print("CardWebSDKExample onReady")
        eventsTextView.text = "\n\n========\n\nonReady\(eventsTextView.text ?? "")"
    }
    
    func onFocus() {
        //print("CardWebSDKExample onFocus")
        eventsTextView.text = "\n\n========\n\nonFocus\(eventsTextView.text ?? "")"
    }
}

