//
//  WebViewViewController.swift
//  Movies
//
//  Created by Kevin Yan on 8/13/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController : UIViewController, WKNavigationDelegate {
//    var requestToken: String?
    weak var delegate : AccountSignInViewControllerDelegate?
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero
            , configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        setupWebView()
        setupWebViewConstraints()
    }
    
    func setupWebView() {
        view.addSubview(webView)
     }
     
     func setupWebViewConstraints() {
         NSLayoutConstraint.activate([
             webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
     }
}
