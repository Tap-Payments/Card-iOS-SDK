//
//  TapCardViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 06/10/2022.
//

import UIKit
import TapUIKit_iOS
import TapCardCheckOutKit

class TapCardViewController: UIViewController {
    
    @IBOutlet weak var tapCardView: TapCardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tapCardView.setupCardForm(collectCardHolderName:true,
                                  transactionCurrency:.SAR,
                                  presentScannerInViewController: self,
                                  preloadCardHolderName: "OSAMA")
        // Do any additional setup after loading the view.
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
