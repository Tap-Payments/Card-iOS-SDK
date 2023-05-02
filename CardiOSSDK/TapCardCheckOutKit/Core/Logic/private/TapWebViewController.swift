//
//  TapWebViewController.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 29/07/2022.
//

import UIKit
import TapUIKit_iOS
import SwiftEntryKit
import TapThemeManager2020
import LocalisationManagerKit_iOS

internal class TapWebViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var closeButton: UIButton!
    
    /// The webview model handler
    internal var webViewModel:TapWebViewModel?
    /// The url to load
    internal var url:URL?
    /// Whether or not to call cancel action
    internal var fireCancelAction:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchThemeAttributes()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let webViewModel = webViewModel, let url = url else { return }
        
        stackView.addArrangedSubview(webViewModel.attachedView)
        DispatchQueue.main.async { [weak self] in
            self?.view.semanticContentAttribute = TapLocalisationManager.shared.localisationLocale == "ar" ? .forceRightToLeft : .forceLeftToRight
            self?.webViewModel?.load(with: url)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if fireCancelAction {
            webViewModel?.delegate?.webViewCanceled(showingFullScreen: false)
        }
        print("DISAPPEAR")
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        SwiftEntryKit.dismiss()
    }
    
    func matchThemeAttributes() {
        //closeButton.setImage(TapThemeManager.imageValue(for: "inlineCard.clearImage.image"), for: .normal)
        closeButton.tap_theme_tintColor = .init(keyPath: "horizontalList.headers.gatewayHeader.leftButton.labelTextColor")
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
        fireCancelAction = false
        dismiss(animated: true)
    }
}
