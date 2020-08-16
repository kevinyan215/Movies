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
    let networkManager = NetworkingManager.shared
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
            rowsToDisplay = watchList
        default:
            rowsToDisplay = favoritesList
        }
        moviesCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
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
            networkManager.getWatchListFor(sessionId: sessionId, completionHandler: fetchMovieClosure)
        } else {
            resetWatchList()
        }
    }
    
    func resetWatchList() {
        self.watchList = []
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
    
    lazy var fetchMovieClosure: (Decodable?, Error?) -> Void = {
        response, error in
        if error != nil {
            self.resetWatchList()
        }
        guard let response = response as? MovieList else { return }
        self.watchList = []
        for movie in response.results {
            if let movie = movie, let movieId = movie.id {
                self.networkManager.getMovieDetailAt(movieId, completionHandler:  {
                    movieResponse, error in
                    guard var movieResponse = movieResponse as? MovieDetail else {return}
                    self.networkManager.getMoviePosterImagesAt(movieResponse.poster_path, completion: {
                        data,error  in
                        movieResponse.poster_image = data
                        self.watchList.append(movieResponse)
                        self.rowsToDisplay = self.watchList
                        DispatchQueue.main.async {
                            self.moviesCollectionView.reloadData()
                        }
                        
                    })

                })
            }
        }
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
