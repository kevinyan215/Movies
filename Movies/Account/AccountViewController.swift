//
//  AccountViewController.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class AccountViewController : UIViewController {
    let signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitleColor(.blue, for: .normal)
        let name = userDefaults.value(forKey: accountIdIdentifier) as? String
        button.setTitle("\(name ?? "") Sign Out", for: .normal)
        button.addTarget(self, action: #selector(signOutButtonClicked), for: .touchDown)
        return button
    }()
    
    @objc func signOutButtonClicked() {
        signOutUser()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor.gray
        
        self.view.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 150),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
