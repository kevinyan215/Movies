//
//  CastCrewCollectionViewCell.swift
//  Movies
//
//  Created by Kevin Yan on 12/16/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit

class CastCrewCollectionViewCell: UICollectionViewCell {

    let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView  = {
        let imageView = UIImageView(frame: .zero)
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
        backgroundColor = UIColor.brown
        
        addSubview(imageView)
        addSubview(nameTitleLabel)
        addSubview(subTitleLabel)
        
        let views: [String:Any] = ["nameTitleLabel": nameTitleLabel, "subTitleLabel": subTitleLabel, "imageView": imageView]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[nameTitleLabel]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subTitleLabel]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]-[nameTitleLabel]-[subTitleLabel]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
    }

}
