//
//  NetworkCallsLogsViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 02/08/2022.
//

import UIKit

class NetworkCallsLogsViewController: UIViewController {
    @IBOutlet weak var logsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logsTextView.text = UIPasteboard.general.string
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
