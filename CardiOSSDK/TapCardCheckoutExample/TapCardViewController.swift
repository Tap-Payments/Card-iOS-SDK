//
//  TapCardViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 06/10/2022.
//

import UIKit
import TapUIKit_iOS
import TapCardCheckOutKit
import CommonDataModelsKit_iOS
import SwiftyGif
import SwiftEntryKit
import SnapKit
class TapCardViewController: UIViewController, TapCardInputDelegatee {
    
    
    func eventHappened(with event: CardKitEventType) {
        //callbackTextView.text = "\(event.description)\n-------\n\(callbackTextView.text ?? "")"
        updateGetItButton()
    }
    
    
    func errorOccured(with error: CardKitErrorType, message:String) {
        var demoTitle:String = ""
        switch error {
        case .Network:
            demoTitle = "Network error"
        case .InvalidCardType:
            demoTitle = "Card type error"
        }
        showAlert(title: demoTitle, message: message)
    }
    
    @IBOutlet weak var tapCardView: TapCardView!
    @IBOutlet weak var getItButton: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var animatedBGImageView: UIImageView!
    var getItAction: ()->() = {}
    
    var savedCustomer:TapCustomer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gif = try! UIImage(gifName: "giphy4.gif")
        animatedBGImageView.setGifImage(gif, loopCount: -1) // Will loop forever
        // Do any additional setup after loading the view.
        tapCardView.translatesAutoresizingMaskIntoConstraints = false
        tapCardView.snp.remakeConstraints { make in
            make.height.equalTo(0)
        }
        tapCardView.layoutIfNeeded()
        configureCardInput()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func getItButtonClicked(_ sender: Any) {
        getItAction()
    }
    
    /// Apply the configurations
    func configureCardInput() {
        
        tapCardView.setupCardForm(locale: sharedConfigurationSharedManager.selectedLocale,
                                   collectCardHolderName: sharedConfigurationSharedManager.collectCardHolderName,
                                   showCardBrandsBar: sharedConfigurationSharedManager.showCardBrands,
                                   showCardScanner: sharedConfigurationSharedManager.showCardScanning,
                                   tapScannerUICustomization: .init(tapFullScreenScanBorderColor: sharedConfigurationSharedManager.scannerColor,
                                                                    blurCardScannerBackground:sharedConfigurationSharedManager.blurScanner),
                                   presentScannerInViewController: self,
                                   allowedCardTypes: sharedConfigurationSharedManager.allowedCardTypes,
                                   tapCardInputDelegate: self,
                                   preloadCardHolderName: (sharedConfigurationSharedManager.cardName == "None") ? "" : sharedConfigurationSharedManager.cardName,
                                  editCardName: sharedConfigurationSharedManager.editCardHolderName,
                                  threeDSConfiguration: .init(backgroundBlurStyle: sharedConfigurationSharedManager.threeDSBlurStyle.toBlurStyle(),
                                                              animationDuration: sharedConfigurationSharedManager.animationDuration,
                                                              threeDsAnimationType: sharedConfigurationSharedManager.animationType,
                                                              showHeaderView: sharedConfigurationSharedManager.showWebViewHeader),
                                  showLoadingState: sharedConfigurationSharedManager.showLoadingState,
                                  floatingSavedCard: sharedConfigurationSharedManager.floatingSavedCard,
                                  forceLTR: sharedConfigurationSharedManager.forceLTR)
    }
    
    
    @IBAction func payOptionChanged(_ sender: Any) {
        guard let segment:UISegmentedControl = sender as? UISegmentedControl else { return }
        
        var toAlpha = 0.0
        
        if segment.selectedSegmentIndex == 0 {
            toAlpha = 0
            tapCardView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }else{
            toAlpha = 1
            tapCardView.snp.remakeConstraints { make in
                make.height.equalTo(158).priority(.high)
            }
            
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.tapCardView.alpha = toAlpha
            self?.tapCardView.layoutIfNeeded()
        }
        updateGetItButton()
    }
    
    
    func updateGetItButton() {
        if segment.selectedSegmentIndex == 0 {
            getItButton.isUserInteractionEnabled = true
            getItButton.alpha = 1
            getItAction = { [weak self] in
                self?.dismiss(animated: true)
            }
        }else{
            getItButton.isUserInteractionEnabled = tapCardView.canProcessCard() ? true : false
            getItButton.alpha = tapCardView.canProcessCard() ? 1 : 0.5
            getItAction = { [weak self] in
                let options:UIAlertController = .init(title: "Many options!", message: "We provide different functionalities on demand. Which one you want to simulate?", preferredStyle: .actionSheet)
                options.addAction(.init(title: "Tokenize", style: .default,handler: { [weak self] _ in
                    self?.tokenizeCardClicked()
                }))
                options.addAction(.init(title: "Save card", style: .default,handler: { [weak self] _ in
                    self?.saveCardClicked()
                }))
                options.addAction(.init(title: "Cancel", style: .cancel,handler: { _ in
                    
                }))
                DispatchQueue.main.async {
                    self?.present(options, animated: true)
                }
            }
        }
    }
    
    func tokenizeCardClicked() {
        self.view.isUserInteractionEnabled = false
        showProcessingNote(attributes: EntriesAttributes.customLoadingAttributes(),text:"Tokenizing the card..")
        tapCardView.tokenizeCard { [weak self] token in
            self?.view.isUserInteractionEnabled = true
            SwiftEntryKit.dismiss()
            print(token.card)
            self?.showAlert(title: "Tokenized", message: token.identifier)
        } onErrorOccured: { [weak self] error, cardFieldsValidity in
            print(error)
            SwiftEntryKit.dismiss()
            self?.view.isUserInteractionEnabled = true
            self?.showAlert(title: "Error", message: "\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
        }
        
    }
    
    
    func saveCardClicked() {
        let alert:UIAlertController = .init(title: "3DS", message: "Always force 3ds?", preferredStyle: .alert)
        alert.addAction(.init(title: "Yes", style: .destructive,handler: { [weak self] _ in
            self?.startSavingCard(enforce3DS: true)
        }))
        alert.addAction(.init(title: "No when possible", style: .default,handler: { [weak self] _ in
            self?.startSavingCard(enforce3DS: false)
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func  startSavingCard(enforce3DS:Bool = true) {
        //self.view.isUserInteractionEnabled = false
        showProcessingNote(attributes: EntriesAttributes.customLoadingAttributes(),text:"Saving card..")
        tapCardView.saveCard(customer: savedCustomer!, parentController: self, metadata: [:]) { [weak self] card in
            print("HERE")
            SwiftEntryKit.dismiss()
            self?.view.isUserInteractionEnabled = true
            UserDefaults.standard.set(try! PropertyListEncoder().encode(card.customer), forKey: "customerSevedKey")
            self?.showAlert(title: "Card saved", message: "\(card.card.lastFourDigits)\n\(card.identifier)")
        } onErrorOccured: { [weak self] error, card, cardFieldsValidity in
            self?.view.isUserInteractionEnabled = true
            SwiftEntryKit.dismiss()
            if let error = error {
                self?.showAlert(title: "Error", message: "\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
            }else if let card = card,
                     let response = card.response,
                     let message = response.message,
                     let errorCode = response.code {
                self?.showAlert(title: "Card save status \(card.status.stringValue)", message: "Backend error message : \(message)\nWith code : \(errorCode)")
            }
        }
    }
    
    
    private func showProcessingNote(attributes: EKAttributes, text:String) {
        let text = text
        let style = EKProperty.LabelStyle(
            font: .systemFont(ofSize: 14, weight: .medium),
            color: .white,
            alignment: .center,
            displayMode: .inferred
        )
        let labelContent = EKProperty.LabelContent(
            text: text,
            style: style
        )
        let contentView = EKProcessingNoteMessageView(
            with: labelContent,
            activityIndicator: UIActivityIndicatorView.Style.medium
        )
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        showAlert(title: "Clicking on actions", message: "This will simulate the case where the card form is embedded inside the consumer's app screen and\n at a point of time, the consumer app asked the card kit to do this certain function.\nThe card kit will execute the required task and will feedback the consumer app, to handle it in its own way.\nHence, making it as flexible as possible.")
    }
    
    
    
    @IBAction func changeCurrency(_ sender: Any) {
        /*switch currencySegment.selectedSegmentIndex {
        case 0: tapCardView.updateTransactionCurrenct(to: .KWD)
        case 1: tapCardView.updateTransactionCurrenct(to: .EGP)
        case 2: tapCardView.updateTransactionCurrenct(to: .SAR)
        default:
            break
        }*/
    }
    
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async { [weak self] in
            let alert:UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            self?.present(alert, animated: true)
        }
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



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
