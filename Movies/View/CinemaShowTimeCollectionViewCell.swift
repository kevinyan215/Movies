//
//  CinemaShowTimeCollectionViewCell.swift
//  Movies
//
//  Created by Kevin Yan on 5/31/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import UIKit

protocol MovieStartTimeButtonDelegate : AnyObject {
    func moviesStartTimeButtonClicked(cell: CinemaShowTimeCollectionViewCell)
}

class CinemaShowTimeCollectionViewCell : UICollectionViewCell {
    weak var delegate: MovieStartTimeButtonDelegate?
    
    let movieStartTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 2
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(moviesStartTimeButtonClicked), for: .touchDown)
        return button
    }()
    
    @objc func moviesStartTimeButtonClicked() {
        self.delegate?.moviesStartTimeButtonClicked(cell: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraints()
        //        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(movieStartTimeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            movieStartTimeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            movieStartTimeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            movieStartTimeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            movieStartTimeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
    }
}


