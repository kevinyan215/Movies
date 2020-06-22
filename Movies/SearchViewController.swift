//
//  SearchViewController.swift
//  Movies
//
//  Created by Kevin Yan on 5/17/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController {
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        configureUI()
    }
    
    func configureUI() {
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(exitSearchBar))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func exitSearchBar() {
        navigationItem.rightBarButtonItem = nil
        searchBar.text = ""
        searchBar.placeholder = "Search"
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(exitSearchBar))
        searchBar.placeholder = nil
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
    }
}
