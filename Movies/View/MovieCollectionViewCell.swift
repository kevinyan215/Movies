//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Kevin Yan on 4/25/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    let movieImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
//        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(movieImage)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            movieImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            movieImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
