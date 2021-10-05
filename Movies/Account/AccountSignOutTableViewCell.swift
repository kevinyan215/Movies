//
//  AccountSignOutTableViewCell.swift
//  Movies
//
//  Created by Kevin Yan on 9/5/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

protocol AccountSignOutTableViewCellDelegate: class {
    func didSelectAccountSignOutTableViewCell()
}

class AccountSignOutTableViewCell: UITableViewCell {
    let signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Sign Out", for: .normal)
//        button.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
        return button
    }()
    var delegate: AccountSignOutTableViewCellDelegate?
    
    @objc func signOutButtonClicked() {
        print("sign out button clicked")
        networkManager.logoutUser(success: {
            response in
            if let response = response as? DeleteSessionResponse, response.success {
                deleteUserData()
                self.delegate?.didSelectAccountSignOutTableViewCell()
            }
        }, failure: {
            error in
            print(error)
        })

     }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(signOutButton)
        signOutButton.addTarget(self, action: #selector(signOutButtonClicked), for: .touchDown)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signOutButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            signOutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 150),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
