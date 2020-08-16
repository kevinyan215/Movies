//
//  AccountViewController.swift
//  Movies
//
//  Created by Kevin Yan on 8/11/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit
import WebKit

class SignInViewController : UIViewController {
    let networkManager = NetworkingManager()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.red
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchDown)
        return button
    }()
    
    @objc func loginButtonClicked() {
        getRequestToken()
    }
    
    func getRequestToken() {
        networkManager.getRequestToken(success: {
           requestToken in
           DispatchQueue.main.async {
               if let requestToken = requestToken as? RequestToken {
                   let vc = WebViewViewController()
                   vc.requestToken = requestToken.request_token
                   self.navigationController?.present(vc, animated: true, completion: nil)
               }
           }
       }, failure: {
           error in
           print(error)
       })
    }
    
    override func viewDidLoad() {
        setupView()
    }
    
    func setupView(){
        view.addSubview(loginButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            loginButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
