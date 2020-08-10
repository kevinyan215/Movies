//
//  MenuCell.swift
//  Movies
//
//  Created by Kevin Yan on 8/9/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        return label
    }()
    
//    override var isHighlighted: Bool {
//        didSet {
//            label.textColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
//        }
//    }
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(label)
        addConstraintsWithFormat("H:[v0(75)]", views: label)
        addConstraintsWithFormat("V:[v0(75)]", views: label)
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
