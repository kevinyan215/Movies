//
//  VideoCollectionViewCell.swift
//  Movies
//
//  Created by Kevin Yan on 11/15/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit
import WebKit

class VideoCollectionViewCell: UICollectionViewCell {

    let videoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
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
        addSubview(videoTitle)
        addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.topAnchor.constraint(equalTo: self.topAnchor),
            webView.widthAnchor.constraint(equalToConstant: 130),
            webView.heightAnchor.constraint(equalToConstant: 145),
            videoTitle.topAnchor.constraint(equalTo: webView.bottomAnchor),
            videoTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            videoTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
//        let views: [String:Any] = ["videoTitle": videoTitle, "webView": webView]
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]-15-[videoTitle]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[videoTitle]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
    }

    func loadVideoFrom(_ urlRequest: URLRequest) {
        webView.load(urlRequest)
    }
}
