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
    }

    @IBAction func tokenizeCardClicked(_ sender: Any) {
        tapCardForum.tokenizeCard { token in
            print(token.card)
        } onErrorOccured: { error in
            print(error)
        }
    }
}

