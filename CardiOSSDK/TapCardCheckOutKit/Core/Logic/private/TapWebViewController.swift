//
//  TapWebViewController.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 29/07/2022.
//

import UIKit
import TapUIKit_iOS

internal class TapWebViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    /// The webview model handler
    internal var webViewModel:TapWebViewModel?
    /// The url to load
    internal var url:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let webViewModel = webViewModel, let url = url else { return }
        
        stackView.addArrangedSubview(webViewModel.attachedView)
        
        webViewModel.load(with: url)
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


extension TapWebViewController: ThreeDSViewControllerDelegatee {
    func disimiss() {
        dismiss(animated: true)
    }
}
