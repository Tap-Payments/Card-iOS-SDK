//
//  CardInputExtensions.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 21/03/2022.
//

import Foundation
import UIKit
import TapUIKit_iOS
import WebKit
import TapCardInputKit_iOS
import TapCardVlidatorKit_iOS
import CommonDataModelsKit_iOS
import TapCardScanner_iOS


internal extension UIView {
    // MARK:- Loading a nib dynamically
    /**
     Load a XIB file into a UIView
     - Parameter bundle: The bundle to load the XIB from, default is the XIB containing the UIView
     - Parameter identefier: The name of the XIB, default is the name of the UIView
     - Parameter addAsSubView: Indicates whether the method should add the loaded XIB into the UIView, default is true
     */
    func setupXIB(from bundle:Bundle? = nil, with identefier: String? = nil, then addAsSubView:Bool = true) -> UIView {
        
        // Whether we use the passed bundle if any, or by default we use the bundle that contains the caller UIView
        let bundle = bundle ?? Bundle(for: Self.self)
        // Whether we use the passed identefier if any, or by default we use the default identefier for self
        let identefier = identefier ??  String(describing: type(of: self))
        
        // Load the XIB file
        guard let nibs = bundle.loadNibNamed(identefier, owner: self, options: nil),
              nibs.count > 0, let loadedView:UIView = nibs[0] as? UIView else { fatalError("Couldn't load Xib \(identefier)") }
        
        let newContainerView = loadedView
        
        //Set the bounds for the container view
        newContainerView.frame = bounds
        newContainerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        // Check if needed to add it as subview
        if addAsSubView {
            addSubview(newContainerView)
        }
        return newContainerView
    }
}


extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}

extension TapCardInputView:TapWebViewModelDelegate {
    
    public func willLoad(request: URLRequest) -> WKNavigationActionPolicy {
        // Double check, there is a url to load :)
        guard let url = request.url else {
            return(.cancel)
        }
        
        // First get the decision based on the loaded url
        let decision = navigationDecision(forWebPayment: url)
        
        // If the redirection finished we need to fetch the object id from the url to further process it
        if decision.redirectionFinished, let tapID = decision.tapID {
            
            // Process the web payment upon getting the transaction ID from the backend url based on the transaction mode Charge or Authorize
            self.tapCardInputDelegate?.eventHappened(with: .ThreeDSEnded)
            self.threeDSDelegate?.disimiss()
            sharedNetworkManager.cardPaymentProcessFinished(with: tapID)
        }else if decision.shouldCloseWebPaymentScreen {
            // The backend told us we need to close the web view :)
            //self.UIDelegate?.closeWebView()
            self.tapCardInputDelegate?.eventHappened(with: .ThreeDSEnded)
            self.threeDSDelegate?.disimiss()
        }
        
        return decision.shouldLoad ? .allow : .cancel
    }
    
    public func didLoad(url: URL?) {}
    
    public func didFail(with error: Error, for url: URL?) {
        // If any error happened, all what we need to do now is to go away :)
        //handleError(error: "Failed to load:\n\(url?.absoluteString ?? "")\nWith Error :\n\(error)")
    }
    
    /**
     Used to decide the decision the web view should do based in the url being requested
     - Parameter forWebPayment url: The url being requested we need to decide the flow based on
     - Returns: The decision based on the url and backend instructions detected inside the url
     */
    internal func navigationDecision(forWebPayment url: URL) -> WebPaymentURLDecision {
        // Detect if the url is the return url (stop redirecting.)
        let urlIsReturnURL = url.absoluteString.starts(with: WebPaymentHandlerConstants.returnURL.absoluteString)
        
        let shouldLoad = !urlIsReturnURL
        let redirectionFinished = urlIsReturnURL
        // Check if the backend passed the ID of the object (charge or authorize)
        let tapID = url[WebPaymentHandlerConstants.tapIDKey]
        let shouldCloseWebPaymentScreen = redirectionFinished// && self.dataHolder.transactionData.selectedPaymentOption?.paymentType == .Card
        
        return WebPaymentURLDecision(shouldLoad: shouldLoad, shouldCloseWebPaymentScreen: shouldCloseWebPaymentScreen, redirectionFinished: redirectionFinished, tapID: tapID)
    }
}


extension TapCardInputView : TapCardInputProtocol {
    public func cardDataChanged(tapCard: TapCard) {
        currentTapCard = tapCard
    }
    
    public func brandDetected(for cardBrand: CardBrand, with validation: CrardInputTextFieldStatusEnum) {
        self.cardBrand = cardBrand
        self.validation = validation
    }
    
    public func scanCardClicked() {
        self.tapCardInput.reset()
        CardValidator.favoriteCardBrand = nil
        showFullScanner()
    }
    
    public func saveCardChanged(enabled: Bool) {
        
    }
    
    public func dataChanged(tapCard: TapCard) {
        currentTapCard = tapCard
    }
    
    public func shouldAllowChange(with cardNumber: String) -> Bool {
        return true
    }
}

extension TapCardInputView: TapCreditCardScannerViewControllerDelegate {
    public func creditCardScannerViewControllerDidCancel(_ viewController: TapFullScreenScannerViewController) {
        viewController.dismiss(animated: true)
    }
    
    public func creditCardScannerViewController(_ viewController: TapFullScreenScannerViewController, didErrorWith error: Error) {
        viewController.dismiss(animated: true)
    }
    
    public func creditCardScannerViewController(_ viewController: TapFullScreenScannerViewController, didFinishWith card: TapCard) {
        //print("\(card.name ?? "")\n\(card.number ?? "")\n\(card.expireDate?.month)\n\(card.expireDate?.year)")
        viewController.dismiss(animated: true,completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                [weak self] in
                self?.tapCardInput.setCardData(tapCard: .init(tapCardNumber: card.tapCardNumber),then: true)
            })
        })
    }
    
    
}

extension TapCardInputView: TapScannerDataSource {
    public func allowedCardBrands() -> [CardBrand] {
        return dataSource.map{ $0.associatedCardBrand }
    }
}
