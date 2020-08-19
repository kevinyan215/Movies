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
        label.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 90),
            label.heightAnchor.constraint(equalToConstant: 75),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
