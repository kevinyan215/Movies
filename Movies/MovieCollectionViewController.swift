//
//  ViewController.swift
//  Movies
//
//  Created by Kevin Yan on 4/20/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController, UICollectionViewDataSource {
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var moviesCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    var tabSelections = ["Popular", "Now Playing"]
//    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let movieTabBar: MovieTabBar = {
        let tabBar = MovieTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = tabSelections[0]
        UINavigationBar.appearance().barTintColor = UIColor.gray
        moviesCollectionView.register(MovieTabBarCell.self, forCellWithReuseIdentifier: "MovieTabBarCell")
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        self.scrollView.delegate = self
        
//        movieCollectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
//        movieCollectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        setupCollectionView()
        setupMovieTabBar()
    }
    
    func setupCollectionView() {
        self.view.addSubview(self.moviesCollectionView)
        self.setupCollectionViewConstraints()
    }
    
    func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupMovieTabBar() {
        self.view.addSubview(movieTabBar)
        setupMovieTabBarConstraints()
    }
    
    func setupMovieTabBarConstraints() {
        NSLayoutConstraint.activate([
            movieTabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            movieTabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            movieTabBar.bottomAnchor.constraint(equalTo: movieCollectionView.topAnchor, constant: 0)
            movieTabBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension MovieCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabSelections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieTabBarCell", for: indexPath) as? MovieTabBarCell {
            cell.delegate = self
            cell.tabSectionSelected = indexPath.row
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}



extension MovieCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MovieCollectionViewController : MovieTabBarCellDelegate {
    func didTapMovieTabBarCellWith(movieDetail: MovieDetail?) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieDetail = movieDetail
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
}
