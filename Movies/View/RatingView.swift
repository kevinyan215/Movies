//
//  RatingView.swift
//  Movies
//
//  Created by Kevin Yan on 8/11/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    var percentValueLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    
    func configureViewFor(voteAverage: Double) {
        let average:CGFloat = CGFloat(voteAverage/10)
        percentValueLabel.text = String(Int(voteAverage*10))
        
        self.backgroundColor = UIColor.clear
//         self.backgroundColor = UIColor.init(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
         let shapeLayer = CAShapeLayer()
         
         let center = CGPoint(x: self.bounds.origin.x + 25, y: self.bounds.origin.y + 25)
         let circularPath = UIBezierPath(arcCenter: center, radius: 20, startAngle: -CGFloat.pi / 2.0, endAngle: 3 * CGFloat.pi / 2.0, clockwise: true)
         shapeLayer.path = circularPath.cgPath
         shapeLayer.fillColor = UIColor.clear.cgColor
         
         let trackLayer = CAShapeLayer()
         trackLayer.path = circularPath.cgPath
         trackLayer.lineWidth = 4
         trackLayer.strokeEnd = 1.0
         trackLayer.fillColor = UIColor.clear.cgColor

         
        if average >= 0.5 {
            shapeLayer.strokeColor = UIColor.init(red: 31/255, green: 209/255, blue: 122/255, alpha: 1.0).cgColor
            trackLayer.strokeColor = UIColor.init(red: 32/255, green: 70/255, blue: 40/255, alpha: 1).cgColor
        } else {
            shapeLayer.strokeColor = UIColor.init(red: 213/255, green: 216/255, blue: 48/255, alpha: 1.0).cgColor
            trackLayer.strokeColor = UIColor.init(red: 66/255, green: 62/255, blue: 14/255, alpha: 1.0).cgColor
        }
        
        shapeLayer.lineWidth =  4
        shapeLayer.strokeEnd = average
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
        
        
    }
    func setupViews() {
        addSubview(percentValueLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            percentValueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            percentValueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            percentValueLabel.widthAnchor.constraint(equalToConstant: 20),
            percentValueLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
