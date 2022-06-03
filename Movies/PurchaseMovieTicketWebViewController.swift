//
//  PurchaseMovieTicketWebViewController.swift
//  Movies
//
//  Created by Kevin Yan on 6/1/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import UIKit

class PurchaseMovieTicketWebViewController : WebViewViewController {
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goToPurchaseTicketsPage(url)
    }
    
    func goToPurchaseTicketsPage(_ url: String?) {
        if let url = URL(string: url ?? ""){
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}
