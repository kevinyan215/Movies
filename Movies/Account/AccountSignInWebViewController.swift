//
//  AccountSIgnInWebViewController.swift
//  Movies
//
//  Created by Kevin Yan on 6/1/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import UIKit
import WebKit

protocol AccountSignInViewControllerDelegate : AnyObject {
    func webViewDidDismiss()
}

class AccountSignInWebViewController : WebViewViewController {
    weak var delegate : AccountSignInViewControllerDelegate?
    var requestToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationController?.delegate = self
        
        if let requestToken = requestToken {
            goToAuthPageWith(requestToken: requestToken)
        }
    }
    
    func goToAuthPageWith(requestToken: String) {
        if let url = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)"){
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}

extension AccountSignInWebViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        newSession()
    }
    
    func newSession() {
        networkManager.newSession(requestToken: requestToken ?? "", success: {
            session in
            if let session = session as? Session, session.success {
                userDefaults.set(session.session_id, forKey: sessionIdIdentifier)
                self.getAccountDetailsWith(sessionId: session.session_id ?? "")
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


