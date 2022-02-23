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
        movieCollectionVC.tabBarItem.image = UIImage(named: "movies_icon")
        
        let myMoviesVC = UINavigationController(rootViewController: MyMoviesViewController())
        myMoviesVC.tabBarItem.title = "My Movies"
        myMoviesVC.tabBarItem.image = UIImage(named: "my_movies_icon")
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem.title = "Search"
        searchVC.tabBarItem.image = UIImage(named: "search_icon")
        
        var accountVC: UIViewController
        if userIsSignedIn() {
            accountVC = UINavigationController(rootViewController: SignInViewController())
            accountVC.addChild(AccountViewController())

        } else {
            accountVC = UINavigationController(rootViewController: SignInViewController())
        }
        accountVC.tabBarItem.title = "Account"
        accountVC.tabBarItem.image = UIImage(named: "account_icon")
        
        viewControllers = [movieCollectionVC, myMoviesVC, searchVC, accountVC]
        
        if #available(iOS 15.0, *) {
           let appearance = UITabBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = UIColor.white
           
           self.tabBar.standardAppearance = appearance
           self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        }
    }
}
