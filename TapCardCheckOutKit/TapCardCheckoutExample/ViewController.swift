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
        // Do any additional setup after loading the view.
        initCardForum()
    }

    
    func initCardForum() {
        let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: "en", secretKey: .init(sandbox: "sk_test_cvSHaplrPNkJO7dhoUxDYjqA", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"))
        tapCardForum.initCardForm(with: cardDataConfig)
    }

}

