//
//  TapWebViewController.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 29/07/2022.
//

import UIKit

internal class TapWebViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
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


extension TapWebViewController: ThreeDSViewControllerDelegate {
    func disimiss() {
        dismiss(animated: true)
    }
}