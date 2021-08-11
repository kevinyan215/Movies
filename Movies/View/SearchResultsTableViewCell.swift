//
//  SearchResultsTableViewCell.swift
//  Movies
//
//  Created by Kevin Yan on 6/29/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell : UITableViewCell {
    
    let movieTitlelabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let moviePosterImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(movieTitlelabel)
        addSubview(moviePosterImage)
//        backgroundColor = UIColor.blue
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            moviePosterImage.heightAnchor.constraint(equalToConstant: 100),
            moviePosterImage.widthAnchor.constraint(equalToConstant: 80),
            moviePosterImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            moviePosterImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
            moviePosterImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
            movieTitlelabel.centerYAnchor.constraint(equalTo: moviePosterImage.centerYAnchor),
//            movieTitlelabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            movieTitlelabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            movieTitlelabel.leadingAnchor.constraint(equalTo: moviePosterImage.trailingAnchor, constant: 10)
//            movieTitlelabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}
