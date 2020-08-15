//
//  AccountViewController.swift
//  Movies
//
//  Created by Kevin Yan on 8/11/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit
import WebKit

class AccountViewController : UIViewController {
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
        networkManager.getRequestToken(completion: {
            token in
            DispatchQueue.main.async {
                let vc = WebViewViewController()
                vc.requestToken = token
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
      
//            DispatchQueue.main.async {
//               self.networkManager.validateWithLogin(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", requestToken: token ?? "", completion: {
//                 token in
////                 print(data)
//                self.networkManager.newSession(requestToken: token ?? "", completion: {
//                    session in
//                    print(session)
//                    UserDefaults.standard.set(session, forKey: "session")
//                })
//             })
//            }
     
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
