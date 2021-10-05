//
//  UIImageView+RoundedCircle.swift
//  Movies
//
//  Created by Kevin Yan on 8/7/21.
//  Copyright © 2021 Kevin Yan. All rights reserved.
//

import UIKit

extension UIImageView {

    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
