//
//  TapCardView+WebDelegate.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 12/09/2023.
//

import Foundation
import UIKit
import WebKit
import SharedDataModels_iOS

extension TapCardView:WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?
        
        defer {
            decisionHandler(action ?? .allow)
        }
        
        guard let url = navigationAction.request.url else { return }
        
        if url.absoluteString.hasPrefix("tapcardwebsdk") {
            action = .cancel
        }else{
            print("navigationAction", url.absoluteString)
        }
        
        switch url.absoluteString {
        case _ where url.absoluteString.contains("onReady"):
            self.animationView?.isHidden = true
            self.webView?.isHidden = false
            delegate?.onReady?()
            break
        case _ where url.absoluteString.contains("onFocus"):
            delegate?.onFocus?()
            break
        case _ where url.absoluteString.contains("onBinIdentification"):
            delegate?.onBinIdentification?(data: tap_extractDataFromUrl(url.absoluteURL))
            break
        case _ where url.absoluteString.contains("onInvalidInput"):
            delegate?.onInvalidInput?(invalid: Bool(tap_extractDataFromUrl(url.absoluteURL).lowercased()) ?? false)
            break
        case _ where url.absoluteString.contains("onError"):
            delegate?.onError?(data: tap_extractDataFromUrl(url.absoluteURL))
            break
        case _ where url.absoluteString.contains("onSuccess"):
            delegate?.onSuccess?(data: tap_extractDataFromUrl(url.absoluteURL))
            break
        case _ where url.absoluteString.contains("on3dsRedirect"):
            handleRedirection(data: tap_extractDataFromUrl(url.absoluteURL))
            break
            
        case _ where url.absoluteString.contains("onHeightChange"):
            
            let height = Double(tap_extractDataFromUrl(url,shouldBase64Decode: false))
            self.changeHeight(to: height)
            break
        default:
            break
        }
    }
}
