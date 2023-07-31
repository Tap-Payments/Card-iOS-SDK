//
//  DirectViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 29/07/2023.
//

import UIKit
import TapCardCheckOutKit
import CommonDataModelsKit_iOS
import LocalisationManagerKit_iOS

class DirectViewController: UIViewController {
    /// The card view reference
    var tapCardView:TapCardView?
    /// The tokenize button
    var tokenizeButton:UIButton = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TapLocalisationManager.shared.localisationLocale = "en"
        view.backgroundColor = .amber
        // Do any additional setup after loading the view.
        // Setup the positiong of the card view,
        // Or you can just use drag and drop features provided by the story board
        setupTokenizeButton()
        // will create the configuration object and call the Tap apis to configure & validate the card data
        configureCardSDK()
    }
    
    
    /// will create the configuration object and call the Tap apis to configure & validate the card data
    func configureCardSDK() {
        // The card data configuration
        let cardDataConfig:TapCardDataConfiguration = .init(publicKey: sharedConfigurationSharedManager.publicKey, scope: sharedConfigurationSharedManager.scope, transcation: sharedConfigurationSharedManager.transcation, merchant: sharedConfigurationSharedManager.merchant, customer: sharedConfigurationSharedManager.customer, acceptance: sharedConfigurationSharedManager.acceptance, fields: sharedConfigurationSharedManager.fields, addons: sharedConfigurationSharedManager.addons, interface: sharedConfigurationSharedManager.interface)
        // let us use the public configure interface
        TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig) {
            DispatchQueue.main.async { [weak self] in
                // This means, all went good! time to setup the card view
                self?.view.isUserInteractionEnabled = true
                self?.setupTapCardConstraints()
                self?.setupCardView()
            }
        } onErrorOccured: { error in
            DispatchQueue.main.async { [weak self] in
                // This means, an error happened! Please check your integration
                self?.view.isUserInteractionEnabled = true
                let uiAlertController:UIAlertController = .init(title: "Error from middleware", message: error?.localizedDescription ?? "", preferredStyle: .actionSheet)
                let uiAlertAction:UIAlertAction = .init(title: "Retry", style: .destructive) { _ in
                    self?.configureCardSDK()
                }
                uiAlertController.addAction(uiAlertAction)
                self?.present(uiAlertController, animated: true)
            }
        }
    }
    /// Do any additional setup after loading the view.
    /// Setup the positiong of the card view,
    /// Or you can just use drag and drop features provided by the story board
    func setupTapCardConstraints() {
        tapCardView = .init()
        view.addSubview(tapCardView!)
        tapCardView?.translatesAutoresizingMaskIntoConstraints = false
        
        // Set it to be edge to edge to the container view
        NSLayoutConstraint(item: tapCardView!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tapCardView!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tapCardView!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 50).isActive = true
        // Set a low highet constraint
        let heightConstraint = NSLayoutConstraint(item: tapCardView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 158)
        heightConstraint.isActive = true
        heightConstraint.priority = .defaultLow
        
        tapCardView?.layoutIfNeeded()
        tapCardView?.updateConstraints()
    }
    
    func setupTokenizeButton() {
        tokenizeButton.setTitle("Tokenize", for: .normal)
        tokenizeButton.backgroundColor = .systemGray2
        
        tokenizeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tokenizeButton)
        
        // Set button constraints
        NSLayoutConstraint(item: tokenizeButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tokenizeButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: tokenizeButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: tokenizeButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
        tokenizeButton.layoutIfNeeded()
        tokenizeButton.updateConstraints()
        
        tokenizeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)


    }
    
    @objc func buttonAction(sender: UIButton!) {
        // Always as a defensive coding, make sure the card can start tokenization
        // by using our validation interface
        guard tapCardView?.canProcessCard() ?? false else { return }
        // This means, we can start the tokenization process
        /**
         Handles tokenizing the current card data.
         - Parameter onTokenReady: A callback to listen when a token is
         successfully generated
         - Parameter onErrorOccured: A callback to listen when tokenization
         fails with error message and the validity of all the card
         fields for your own interest
         */
        tapCardView?.tokenizeCard { token in
            print(token.card)
        } onErrorOccured: { error, cardFieldsValidity in
            print(error)
            print("\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
        }
    }
    
    /// Will assign the delegate of the card view
    func setupCardView() {
        tapCardView?.setupCardForm(presentScannerInViewController: self, tapCardInputDelegate: self)
        // Only make it visible after successful configuration
        tapCardView?.isHidden = false
    }
}

extension DirectViewController: TapCardInputDelegate {
    func eventHappened(with event: CardKitEventType) {
        print(event.description)
        if event == .CardNotReady {
            tokenizeButton.alpha = 0.5
            tokenizeButton.isEnabled = false
        }else if event == .CardReady {
            tokenizeButton.alpha = 1
            tokenizeButton.isEnabled = true
        }
    }
    
    func errorOccured(with error: CardKitErrorType, message:String) {
        print("\(error.description) with \(message)")
    }
}
