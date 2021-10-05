//
//  AccountViewController.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class AccountViewController : UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountUserNameTableViewCell.self, forCellReuseIdentifier: AccountUserNameTableViewCellId)
        tableView.register(AccountSignOutTableViewCell.self, forCellReuseIdentifier: AccountSignOutTableViewCellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
//        self.view.backgroundColor = UIColor.gray
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension AccountViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AccountUserNameTableViewCellId) as? AccountUserNameTableViewCell {
                cell.userNameLabel.text = userDefaults.value(forKey: accountUsernameIdentifier) as? String
                cell.isUserInteractionEnabled = false
                return cell
            }
        } else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AccountSignOutTableViewCellId) as? AccountSignOutTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
}

extension AccountViewController : AccountSignOutTableViewCellDelegate {
    func didSelectAccountSignOutTableViewCell() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AccountViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100.0
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
