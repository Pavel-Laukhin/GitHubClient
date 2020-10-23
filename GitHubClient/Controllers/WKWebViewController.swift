//
//  WKWebViewController.swift
//  GitHubClient
//
//  Created by Павел on 23.10.2020.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKNavigationDelegate {
    
    private var url: String
    private var webView: WKWebView!

    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
        // Устанавливаем цвет фона страницы с помощью Java-скрипта:
        let color = #colorLiteral(red: 0.5949709415, green: 0.9076359868, blue: 0.4050972462, alpha: 1).hexString()
        let source = "document.body.style.background = \"\(color)\";"
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        webConfiguration.userContentController = userContentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActivityIndicatorViewController.startAnimating(in: self)
        
        if let myURL = URL(string: url) {
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(type(of: self), #function)
        ActivityIndicatorViewController.stopAnimating(in: self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ActivityIndicatorViewController.stopAnimating(in: self)
    }
    
}


extension UIColor {
    
    func hexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
     }
    
}
