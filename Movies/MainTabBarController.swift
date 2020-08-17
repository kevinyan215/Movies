//
//  MainTabBarController.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        setupTabBar()
    }
        
    func setupTabBar() {
        let movieCollectionVC = UINavigationController(rootViewController: MovieCollectionViewController())
        movieCollectionVC.tabBarItem.title = "Movies"
        
        let myMoviesVC = UINavigationController(rootViewController: MyMoviesViewController())
        myMoviesVC.tabBarItem.title = "My Movies"
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem.title = "Search"
        
        var accountVC: UIViewController
        if userIsSignedIn() {
            accountVC = UINavigationController(rootViewController: SignInViewController())
            accountVC.addChild(AccountViewController())

        } else {
            accountVC = UINavigationController(rootViewController: SignInViewController())

        }
        accountVC.tabBarItem.title = "Account"
        
        viewControllers = [movieCollectionVC, myMoviesVC, searchVC, accountVC]
    }
}
