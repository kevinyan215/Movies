//
//  ViewController.swift
//  Movies
//
//  Created by Kevin Yan on 4/20/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var contentView: UIView!
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
    
    lazy var movieTabBar: MovieTabBar = {
        let tabBar = MovieTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.movieCollectionViewController = self
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
        
//        moviesCollectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
//        moviesCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        setupCollectionView()
        setupMovieTabBar()
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        moviesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupCollectionView() {
        self.contentView.addSubview(self.moviesCollectionView)
        self.setupCollectionViewConstraints()
    }
    
    func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0), //-87
            moviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setupMovieTabBar() {
        self.contentView.addSubview(movieTabBar)
        setupMovieTabBarConstraints()
    }
    
    func setupMovieTabBarConstraints() {
        NSLayoutConstraint.activate([
            movieTabBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            movieTabBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieTabBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        movieTabBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 5
    }
}

extension MovieCollectionViewController : MovieTabBarCellDelegate {
    func didTapMovieTabBarCellWith(movieDetail: MovieDetail?) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieDetail = movieDetail
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
}
