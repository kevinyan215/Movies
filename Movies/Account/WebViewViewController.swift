//
//  WebViewViewController.swift
//  Movies
//
//  Created by Kevin Yan on 8/13/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit
import WebKit

//protocol WebViewViewControllerDelegate : class {
//
//}

class WebViewViewController : UIViewController, WKNavigationDelegate {
    
    var requestToken: String?
//    weak var delegate : WebViewViewControllerDelegate?
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero
            , configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        setupWebView()
        
        if let requestToken = requestToken {
            goToAuthPageWith(requestToken: requestToken)
        }
    }
    
    func setupWebView() {
        view.addSubview(webView)
        self.presentationController?.delegate = self

        setupWebViewConstraints()
     }
     
     func setupWebViewConstraints() {
         NSLayoutConstraint.activate([
             webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
     }
    
    func goToAuthPageWith(requestToken: String) {
        if let url = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)"){
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}

extension WebViewViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        newSession()
    }
    
    func newSession() {
        NetworkingManager.shared.newSession(requestToken: requestToken ?? "", success: {
            session in
            if let session = session as? Session, session.success {
                UserDefaults.standard.set(session.session_id, forKey: sessionIdIdentifier)
            }
        }, failure: {
            error in
            print(error)
        })
    }
}
