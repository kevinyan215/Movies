//
//  AccountUserNameTableViewCell.swift
//  Movies
//
//  Created by Kevin Yan on 9/5/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class AccountUserNameTableViewCell: UITableViewCell {

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(userNameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: 300),
            userNameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
