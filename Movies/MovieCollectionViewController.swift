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
    @IBOutlet weak var scrollView: UIScrollView!

    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var moviesCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.gray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 200,left: 0,bottom: 0,right: 0)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
        collectionView.isPagingEnabled = true
        collectionView.register(PopularMoviesCell.self, forCellWithReuseIdentifier: PopularMoviesCellId)
        collectionView.register(NowPlayingMoviesCell.self, forCellWithReuseIdentifier: NowPlayingMoviesCellId)
        collectionView.register(TopRatedMoviesCell.self, forCellWithReuseIdentifier: TopRatedMoviesCellId)
        collectionView.register(UpcomingMoviesCell.self, forCellWithReuseIdentifier: UpcomingMoviesCellId)
        collectionView.register(MovieTabBarCell.self, forCellWithReuseIdentifier: MovieTabBarCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var movieTabBar: MovieTabBar = {
        let tabBar = MovieTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.movieCollectionViewController = self
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = movieTabBar.tabSelections[0]
//        UINavigationBar.appearance().barTintColor = UIColor.gray

//        self.scrollView.delegate = self
    
        setupMovieTabBar()
        setupCollectionView()
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
            moviesCollectionView.topAnchor.constraint(equalTo: movieTabBar.bottomAnchor, constant: 0),
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
            movieTabBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension MovieCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieTabBar.tabSelections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        if indexPath.item == 0 {
            identifier = PopularMoviesCellId
        } else if indexPath.item == 1 {
            identifier = TopRatedMoviesCellId
        } else if indexPath.item == 2  {
            identifier = NowPlayingMoviesCellId
        } else if indexPath.item == 3 {
            identifier = UpcomingMoviesCellId
        }
        else {
            identifier =  MovieTabBarCellId
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MovieTabBarCell {
            cell.delegate = self
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
        movieTabBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / CGFloat(movieTabBar.tabSelections.count)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        movieTabBar.menuTabsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        setTitleForIndex(index: index)
    }
    
    func setTitleForIndex(index: Int) {
        navigationItem.title = "\(movieTabBar.tabSelections[index])"
    }
}

extension MovieCollectionViewController : MovieTabBarCellDelegate {
    func didTapMovieTabBarCellWith(movieDetail: MovieDetail?) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieDetail = movieDetail
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
}
