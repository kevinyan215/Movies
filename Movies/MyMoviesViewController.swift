//
//  MyMoviesViewController.swift
//  Movies
//
//  Created by Kevin Yan on 8/14/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

protocol MyMoviesViewControllerDelegate : class {
    func didTapMovieTabBarCellWith(movieDetail: MovieDetail)
}

class MyMoviesViewController : UIViewController {
    var watchList: [MovieDetail] = []
    var favoritesList: [MovieDetail] = []
    lazy var rowsToDisplay: [MovieDetail] = watchList
    weak var delegate: MyMoviesViewControllerDelegate?
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
           let layout = UICollectionViewFlowLayout()
           let numberOfCellsPerRow: CGFloat = 2
           let horizontalSpacing = layout.scrollDirection == .vertical ? layout.minimumInteritemSpacing : layout.minimumLineSpacing
           let cellWidth = (self.view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
           layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 40)
           return layout
       }()
       
    lazy var moviesCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: movieCollectionViewCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Watch list", "Favorites"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlChange), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    @objc func segmentedControlChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.setRowsToDisplay(list: self.watchList)
        default:
            self.setRowsToDisplay(list: self.favoritesList)
        }
        moviesCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        setupStackViews()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWatchList()
    }
    
    func setupStackViews() {
        let paddedStackView = UIStackView(arrangedSubviews: [segmentedControl])
        paddedStackView.layoutMargins = .init(top:12, left: 12, bottom:6, right: 12)
        paddedStackView.isLayoutMarginsRelativeArrangement = true
          
        let stackView = UIStackView(arrangedSubviews: [paddedStackView,  moviesCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
        
    func getWatchList() {
        let sessionId = UserDefaults.standard.value(forKey: sessionIdIdentifier) as? String
        if let sessionId = sessionId {
            networkManager.getWatchListFor(sessionId: sessionId, completionHandler: self.getMovieList(completionHandler: self.fetchWatchListResponse))
        } else {
            resetWatchList()
        }
    }
    
    func resetWatchList() {
        self.clearWatchList()
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
    
    func clearWatchList() {
        self.watchList = []
        self.setRowsToDisplay(list: self.watchList)
    }
    
    func setRowsToDisplay(list: [MovieDetail]) {
        self.rowsToDisplay = list
    }
    
    func getMovieList(completionHandler: @escaping (Decodable?, Error?) -> ()) -> (Decodable?, Error?) -> Void {
        return {
            response, error in
            if error != nil {
                self.clearWatchList()
            }
            guard let response = response as? MovieList else { return }
            self.clearWatchList()
            for movie in response.results {
                if let movie = movie, let movieId = movie.id {
                    self.getMovieDetailAt(movieId: movieId, completionHandler: completionHandler)
                }
            }
        }
        
    }
    
    func getMovieDetailAt(movieId: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        networkManager.getMovieDetailAt(movieId, completionHandler: completion)
    }
    
    func getMoviePosterImagesAt(completionHandler: @escaping (MovieDetail) -> ()) -> (Decodable?, Error?) -> Void {
        return { movieResponse, error in
            guard var movieResponse = movieResponse as? MovieDetail else {return}
            networkManager.getMoviePosterImagesAt(movieResponse.poster_path, completion: { data,error  in
                movieResponse.poster_image = data
                completionHandler(movieResponse)
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            })
        }
    }
    
    lazy var favoritesListResponse = getMoviePosterImagesAt { response in
        self.favoritesList.append(response)
        self.setRowsToDisplay(list: self.favoritesList)
    }
    
    lazy var fetchWatchListResponse = getMoviePosterImagesAt { response in
        self.watchList.append(response)
        self.setRowsToDisplay(list: self.watchList)
    }
    
    
   
    
    
}

extension MyMoviesViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCollectionViewCellIdentifier, for: indexPath) as? MovieCollectionViewCell {
            cell.movieImage.image = nil
            if let data = rowsToDisplay[indexPath.item].poster_image,
                let poster_image = UIImage(data: data) {
                    cell.movieImage.image = poster_image
            }
            cell.ratingView.configureViewFor(voteAverage: rowsToDisplay[indexPath.item].vote_average ?? 0.0)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension MyMoviesViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieDetail = rowsToDisplay[indexPath.item]
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

