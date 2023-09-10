//
//  WebCardView.swift
//  TapCardCheckOutKit
//
//  Created by MahmoudShaabanAllam on 07/09/2023.
//

import UIKit
import WebKit
import SnapKit
import Lottie
import SharedDataModels_iOS
import Foundation
/// A protocol that allows integrators to get notified from events fired from Tap card sdk
@objc public protocol TapCardViewDelegate {
    /// Will be fired whenever the card is rendered and loaded
    @objc optional func onReady()
    /// Will be fired once the user focuses any of the card fields
    @objc optional func onFocus()
    /// Will be fired once we detect the brand and related issuer data for the entered card data
    /** - Parameter data: will include the data in JSON format. example :
     *{
        "bin": "424242",
        "bank": "",
        "card_brand": "VISA",
        "card_type": "CREDIT",
        "card_category": "",
        "card_scheme": "VISA",
        "country": "GB",
        "address_required": false,
        "api_version": "V2",
        "issuer_id": "bnk_TS02A5720231337s3YN0809429",
        "brand": "VISA"
     }*     */
    @objc optional func onBinIdentification(data: String)
    /// Will be fired whenever the validity of the card data changes.
    /// - Parameter invalid: Will be true if the card data is invalid and false otherwise.
    @objc optional func onInvalidInput(invalid: Bool)
    /**
        Will be fired whenever the card sdk finishes successfully the task assigned to it. Whether `TapToken` or `AuthenticatedToken`
     - Parameter data: will include the data in JSON format. For `TapToken`:
     {
         "id": "tok_MrL97231045SOom8cF8G939",
         "created": 1694169907939,
         "object": "token",
         "live_mode": false,
         "type": "CARD",
         "source": "CARD-ENCRYPTED",
         "used": false,
         "card": {
             "id": "card_d9Vj7231045akVT80B8n944",
             "object": "card",
             "address": {},
             "funding": "CREDIT",
             "fingerprint": "gRkNTnMrJPtVYkFDVU485Gc%2FQtEo%2BsV44sfBLiSPM1w%3D",
             "brand": "VISA",
             "scheme": "VISA",
             "category": "",
             "exp_month": 4,
             "exp_year": 24,
             "last_four": "4242",
             "first_six": "424242",
             "name": "AHMED",
             "issuer": {
                "bank": "",
                "country": "GB",
                "id": "bnk_TS07A0720231345Qx1e0809820"
            }
         },
         "url": ""
     }
     */
    @objc optional func onSuccess(data: String)
    /// Will be fired whenever there is an error related to the card connectivity or apis
    /// - Parameter data: includes a JSON format for the error description and error
    @objc optional func onError(data: String)
    /// Will be fired whenever the card element changes its height for your convience
    /// - Parameter height: The new needed height
    @objc optional func onHeightChange(height: Double)
}


/// The custom view that provides an interface for the Tap card sdk form
@objc public class TapCardView: UIView {
    /// The web view used to render the tap card sdk
    internal var webView: WKWebView?
    /// A protocol that allows integrators to get notified from events fired from Tap card sdk
    internal var delegate: TapCardViewDelegate?
    /// A lottie animation to provide the shimmering loading before rendering
    internal var animationView: LottieAnimationView?
    /// Defines the base url for the Tap card sdk
    internal static let tapCardBaseUrl:String = "https://demo.dev.tap.company/v2/sdk/checkout?type=card-iframe&configurations="
    
    //MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //MARK: - Private methods
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        setupWebView()
        setupShimmeringView()
        setupConstraints()
    }
    
    
    /// Used to open a url inside the Tap card web sdk.
    /// - Parameter url: The url needed to load.
    private func openUrl(url: URL?) {
        // First let us hide the web view and show the loading view
        webView?.isHidden = true
        animationView?.isHidden = false
        // Second, instruct the web view to load the needed url
        let request = URLRequest(url: url!)
        webView?.navigationDelegate = self
        webView?.load(request)
    }
    
    /// used to setup the constraint of the Tap card sdk view
    private func setupWebView() {
        // Creates needed configuration for the web view
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        // Let us make sure it is of a clear background and opaque, not to interfer with the merchant's app background
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.clear
        webView?.scrollView.backgroundColor = UIColor.clear
        webView?.scrollView.bounces = false
        webView?.isHidden = true
        // Let us add it to the view
        self.backgroundColor = .clear
        self.addSubview(webView!)
    }
    
    /// used to setup the constraint of the shimmerling loading view
    private func setupShimmeringView() {
        // let us load the correct shimmerling lottie json file
        animationView = .init(name: "Light_Mode_Button_Loader", bundle: Bundle(for: TapCardView.self))
        setAnimationLoader()
        // let us set the needed configuratons for the shimmering view
        animationView!.frame = .zero
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.75
        // Add it to the view
        self.addSubview(animationView!)
        animationView!.play()
    }
    
    
    /// Setup Constaraints for the sub views.
    private func setupConstraints() {
        // Defensive coding
        guard let webView = self.webView,
        let animationView = self.animationView else {
            return
        }
        
        // Preprocessing needed setup
        webView.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        // Define the web view constraints
        let top  = webView.topAnchor.constraint(equalTo: self.topAnchor)
        let left = webView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let right = webView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bottom = webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let cardHeight = self.heightAnchor.constraint(greaterThanOrEqualToConstant: 95)
        
        // Define the shimmering view constraints
        let topanimationView  = animationView.topAnchor.constraint(equalTo: self.webView!.topAnchor)
        let leftanimationView = animationView.leftAnchor.constraint(equalTo: self.webView!.leftAnchor)
        let rightanimationView = animationView.rightAnchor.constraint(equalTo: self.webView!.rightAnchor)
        let shimmerHeight = self.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
        
        // Activate the constraints
        NSLayoutConstraint.activate([left, right, top, bottom, cardHeight])
        NSLayoutConstraint.activate([leftanimationView, rightanimationView, topanimationView, shimmerHeight])
    }
    
    /// Decides which lottie json animation file to be used based on the current theme of the device
    internal func setAnimationLoader() {
        if self.traitCollection.userInterfaceStyle == .dark {
            animationView?.animation = .named("Dark_Mode_Button_Loader", bundle: Bundle(for: TapCardView.self))
        }else{
            animationView?.animation = .named("Light_Mode_Button_Loader", bundle: Bundle(for: TapCardView.self))
        }
    }
    
    /// Auto adjusts the height of the card view
    /// - Parameter to newHeight: The new height the card view should expand/shrink to
    internal func changeHeight(to newHeight:Double?) {
        // make sure we are in the main thread
        DispatchQueue.main.async {
            // move to the new height or safely to the default height
            self.snp.updateConstraints { make in
                make.height.equalTo(newHeight ?? 95)
            }
            // Update the layout of the affected views
            self.layoutIfNeeded()
            self.updateConstraints()
            self.layoutSubviews()
            self.webView?.layoutIfNeeded()
            self.animationView?.layoutIfNeeded()
        }
    }
    
    //MARK: - Public init methods
    ///  configures the tap card sdk with the needed configurations for it to work
    ///  - Parameter config: The configurations model
    ///  - Parameter delegate:A protocol that allows integrators to get notified from events fired from Tap card sdk
    @objc public func initTapCardSDK(config: TapCardConfiguration, delegate: TapCardViewDelegate? = nil) {
        self.delegate = delegate
        do {
            try openUrl(url: URL(string: generateTapCardSdkURL(from: config)))
        }catch {
            self.delegate?.onError?(data: "{error:\(error.localizedDescription)}")
        }
    }
    
    ///  configures the tap card sdk with the needed configurations for it to work
    ///  - Parameter config: The configurations dctionary. Recommended, as it will make you able to customly add models without updating
    ///  - Parameter delegate:A protocol that allows integrators to get notified from events fired from Tap card sdk
    @objc public func initTapCardSDK(configDict: [String : Any], delegate: TapCardViewDelegate? = nil) {
        self.delegate = delegate
        do {
            try openUrl(url: URL(string: generateTapCardSdkURL(from: configDict)))
        }
        catch {
            self.delegate?.onError?(data: "{error:\(error.localizedDescription)}")
        }
    }
    
    ///  configures the tap card sdk with the needed configurations for it to work
    ///  - Parameter config: The configurations string json format. Recommended, as it will make you able to customly add models without updating
    ///  - Parameter delegate:A protocol that allows integrators to get notified from events fired from Tap card sdk
    @objc public func initTapCardSDK(configString: String, delegate: TapCardViewDelegate? = nil) {
        self.delegate = delegate
        openUrl(url: URL(string: generateTapCardSdkURL(from: configString))!)
    }
    
    
    //MARK: - Public interfaces
    
    /// Wil start the process of generating a `TapToken` with the current card data
    @objc public func generateTapToken() {
        // Let us instruct the card sdk to start the tokenizaion process
        webView?.evaluateJavaScript("window.generateTapToken()")
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
        setAnimationLoader()
    }
}


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
            
        case _ where url.absoluteString.contains("onHeightChange"):
            
            let height = Double(tap_extractDataFromUrl(url,shouldBase64Decode: false))
            self.changeHeight(to: height)
            break
        default:
            break
        }
    }
}

