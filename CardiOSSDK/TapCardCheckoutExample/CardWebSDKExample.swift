//
//  CardWebSDKExample.swift
//  TapCardCheckoutExample
//
//  Created by MahmoudShaabanAllam on 06/09/2023.
//

import UIKit
import WebKit
import TapCardCheckOutKit

class CardWebSDKExample: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WebCardView!
    @IBOutlet weak var button: UIButton!
    
    var config: CardWebSDKConfig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.setDelegate(delegate: self)
//        webView?.initWebCardSDK(config: config!)
        webView?.initWebCardSDK(configString: """
{"publicKey":"pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7","merchant":{"id":""},"transaction":{"amount":1,"currency":"SAR"},"customer":{"id":"","name":[{"lang":"en","first":"Ahmed","last":"Sharkawy","middle":"Mohamed"}],"nameOnCard":"Ahmed Sharkawy","editable":true,"contact":{"email":"ahmed@gmail.com","phone":{"countryCode":"20","number":"1000000000"}}},"acceptance":{"supportedBrands":["AMEX","VISA","MASTERCARD","MADA"],"supportedCards":["CREDIT","DEBIT"]},"fields":{"cardHolder":true},"addons":{"displayPaymentBrands":true,"loader":true,"saveCard":true},"interface":{"locale":"en","theme":"light","edges":"curved","direction":"ltr"}}
""")
        //self.view.backgroundColor = .blue
    }

    
    @IBAction func generateToken(_ sender: Any) {
        webView?.generateTapToken()
    }

    
    func setConfig(config: CardWebSDKConfig) {
        self.config = config
    }
}

extension CardWebSDKExample: WebCardViewDelegate {
    func onHeightChange(height: Double) {
        print("CardWebSDKExample onHeightChange \(height)")
    }
    
    func onBinIdentification(data: String) {
        print("CardWebSDKExample onBinIdentification \(data)")

    }
    
    func onValidInput(valid: Bool) {
        print("CardWebSDKExample onValidInput \(valid)")

    }
    
    func onInvalidInput(invalid: Bool) {
        print("CardWebSDKExample onInvalidInput \(invalid)")
    }
    
    func onSuccess(data: String) {
        print("CardWebSDKExample onSuccess \(data)")

    }
    
    func onError(data: String) {
        print("CardWebSDKExample onError \(data)")

    }
    
    func onReady(){
        print("CardWebSDKExample onReady")
    }
    
    func onFocus() {
        print("CardWebSDKExample onFocus")
        
    }
}

