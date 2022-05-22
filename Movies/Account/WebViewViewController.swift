//
//  WebViewViewController.swift
//  Movies
//
//  Created by Kevin Yan on 8/13/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate : AnyObject {
    func webViewDidDismiss()
}

class WebViewViewController : UIViewController, WKNavigationDelegate {
    var requestToken: String?
    weak var delegate : WebViewViewControllerDelegate?
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
        networkManager.newSession(requestToken: requestToken ?? "", success: {
            [weak self] session in
            if let session = session as? Session, session.success {
                userDefaults.set(session.session_id, forKey: sessionIdIdentifier)
                self?.getAccountDetailsWith(sessionId: session.session_id ?? "")
            }
        }, failure: {
            error in
            print(error)
        })
    }
    
    func getAccountDetailsWith(sessionId: String){
        networkManager.getAccountDetailsWith(sessionId: sessionId, success: {
            [weak self] account in
            if let account = account as? Account {
                userDefaults.set(account.username, forKey: accountUsernameIdentifier)
                userDefaults.set(account.id, forKey: accountIdIdentifier)
                self?.delegate?.webViewDidDismiss()
            }
        }, failure: {
            error in
            print(error)
        })
    }
}
