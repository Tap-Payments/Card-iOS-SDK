//
//  WebCardView.swift
//  TapCardCheckOutKit
//
//  Created by MahmoudShaabanAllam on 07/09/2023.
//

import UIKit
import WebKit

protocol WebCardViewDelegate {
    func onReady()
    func onFocus()
    func onBinIdentification(data: String)
    func onValidInput(valid: Bool)
    func onInvalidInput(invalid: Bool)
    func onSuccess(data: String)
    func onError(data: String)
    func onHeightChange(height: Double)
    
}
class WebCardView: UIView, WKNavigationDelegate {
    
    var webView: WKWebView?
    var delegate: WebCardViewDelegate?
    
    
    //MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        setupWebView()
        setupConstraints()
    }
    
    
    private func openUrl(url: URL?) {
        let request = URLRequest(url: url!)
        webView?.navigationDelegate = self
        webView?.load(request)
    }
    
    private func setupWebView() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        self.backgroundColor = .clear
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.clear
        webView?.scrollView.backgroundColor = UIColor.clear
        self.addSubview(webView!)
    }
    
    
    //-- Setup Constaraints for WebView.
    private func setupConstraints() {
        guard let webView = self.webView else {
            return
        }
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let top  = webView.topAnchor.constraint(equalTo: self.topAnchor)
        let left = webView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let right = webView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bottom = webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let height = self.heightAnchor.constraint(greaterThanOrEqualToConstant: 95)
        NSLayoutConstraint.activate([left, right, top, bottom, height])
    }
    
    func initWebCardSDK(config: CardWebSDKConfig) {
        initWebView( config.dictionary ?? [:])
    }
    
    func setDelegate(delegate: WebCardViewDelegate) {
        self.delegate = delegate
    }
    
    func initWebCardSDK(configDict: [String : Any]) {
        initWebView(configDict)
    }
    
    func initWebCardSDK(configString: String) {
        let urlEncodedJson = configString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let urlString = "https://demo.dev.tap.company/v2/sdk/checkout?type=card-iframe&configurations=\(urlEncodedJson!)"
        openUrl(url: URL(string: urlString)!)
    }
    
    
    fileprivate func initWebView(_ configDict: [String : Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: configDict, options: .prettyPrinted)
            let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
            let urlEncodedJson = jsonString!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            let urlString = "https://demo.dev.tap.company/v2/sdk/checkout?type=card-iframe&configurations=\(urlEncodedJson!)"
            openUrl(url: URL(string: urlString)!)
        }
        catch let JSONError as NSError {
            print("\(JSONError)")
        }
    }
    
    
    func getURLComonents(_ urlString: String?) -> NSURLComponents? {
        var components: NSURLComponents? = nil
        let linkUrl = URL(string: urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        if let linkUrl = linkUrl {
            components = NSURLComponents(url: linkUrl, resolvingAgainstBaseURL: true)
        }
        return components
    }
    
    func getQueryItems(_ urlString: String) -> [String : String] {
        var queryItems: [String : String] = [:]
        let components: NSURLComponents? = getURLComonents(urlString)
        for item in components?.queryItems ?? [] {
            queryItems[item.name] = item.value?.removingPercentEncoding
        }
        return queryItems
    }
    
    func generateTapToken() {
        webView?.evaluateJavaScript("window.generateTapToken()")
    }
    
    fileprivate func extractDataFromUrl(_ url: URL) -> String {
        if let stringData = getQueryItems(url.absoluteString)["data"], let stringValue = stringData.fromBase64() {
            return stringValue
        } else {
            return ""
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?
        
        defer {
            decisionHandler(action ?? .allow)
        }
        
        guard let url = navigationAction.request.url else { return }
        print("navigationAction", url.absoluteString)
        
        switch url.absoluteString {
        case _ where url.absoluteString.contains("onReady"):
            delegate?.onReady()
            break
        case _ where url.absoluteString.contains("onFocus"):
            delegate?.onFocus()
            break
        case _ where url.absoluteString.contains("onBinIdentification"):
            delegate?.onBinIdentification(data: extractDataFromUrl(url.absoluteURL))
            break
        case _ where url.absoluteString.contains("onValidInput"):
            delegate?.onValidInput(valid: extractDataFromUrl(url.absoluteURL).boolValue ?? false)
            break
        case _ where url.absoluteString.contains("onInvalidInput"):
            delegate?.onInvalidInput(invalid: extractDataFromUrl(url.absoluteURL).boolValue ?? false)
            break
        case _ where url.absoluteString.contains("onError"):
            delegate?.onError(data: extractDataFromUrl(url.absoluteURL))
            break
            
        case _ where url.absoluteString.contains("onSuccess"):
            delegate?.onSuccess(data: extractDataFromUrl(url.absoluteURL))
            break
            
        case _ where url.absoluteString.contains("onHeightChange"):
            print(getQueryItems(url.absoluteString)["data"])
            let height = Double(getQueryItems(url.absoluteString)["data"] ?? "95")
            delegate?.onHeightChange(height: height ?? 95)
            break
        default:
            break
        }
    }
    
}



extension String {
    func fromBase64() -> String? {
        guard let base64EncodedData = self.data(using: .ascii) else {
            return nil
        }
        if let base64Decoded = Data(base64Encoded: base64EncodedData, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
            return base64Decoded
        }
        return nil
    }
    
    var boolValue: Bool? {
        guard let startIndex = self.firstIndex(where: { !$0.isWhitespace }) else {
            return nil
        }
        
        let endIndex = self.lastIndex(where: { !$0.isWhitespace }) ?? self.endIndex
        let trimmed = self[startIndex...endIndex]
        switch trimmed.lowercased() {
        case "true","yes": return true
        case "false","no": return false
        default: return nil
        }
    }
}



extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

