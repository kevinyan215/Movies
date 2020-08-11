//
//  MovieTabBarCell.swift
//  Movies
//
//  Created by Kevin Yan on 8/7/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

protocol MovieTabBarCellDelegate : class {
    func didTapMovieTabBarCellWith(movieDetail: MovieDetail?)
}

class MovieTabBarCell : UICollectionViewCell {
    weak var delegate: MovieTabBarCellDelegate?
//    var dict: [Int:[MovieDetail]] = [:]
    var tabSectionSelected: Int = 0
    var popularMovies:[MovieDetail] = []
    var nowPlayingMovies: [MovieDetail] = []
    var firstTimePopularMovieCall = true
    var firstTimeNowPlayingMovieCall = true

    let networkManager = NetworkingManager.shared

    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let numberOfCellsPerRow: CGFloat = 2
        let horizontalSpacing = layout.scrollDirection == .vertical ? layout.minimumInteritemSpacing : layout.minimumLineSpacing
        let cellWidth = (self.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        return layout
    }()
    
    lazy var moviesCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        self.addSubview(moviesCollectionView)
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: movieCollectionViewCellIdentifier)
        self.moviesCollectionView.dataSource = self
        self.moviesCollectionView.delegate = self
        
//        dict[0] = popularMovies
//        dict[1] = nowPlayingMovies
        self.setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

        ])
    }
    
    func getNowPlayingMovies() {
        networkManager.getNowPlayingMovies(completion: {
            response in
            guard let response = response else { return }
            for movie in response.results {
                if let movie = movie, let movieId = movie.id {
                    self.networkManager.getMovieDetailAt(movieId, completion:  {
                        movieResponse in
                        guard var movieResponse = movieResponse else {return}
                        self.networkManager.getMoviePosterImagesAt(movieResponse.poster_path, completion: {
                            data in
                            movieResponse.poster_image = data
//                            self.dict[1]?.append(movieResponse)
                            self.nowPlayingMovies.append(movieResponse)
                            DispatchQueue.main.async {
                                self.moviesCollectionView.reloadData()
                            }
                            
                        })

                    })
                }
            }
        })
    }
    func getPopularMovies() {
        networkManager.getPopularMovies(completion: {
            response in
            guard let response = response else { return }
            for movie in response.results {
                if let movie = movie, let movieId = movie.id {
                    self.networkManager.getMovieDetailAt(movieId, completion:  {
                        movieResponse in
                        guard var movieResponse = movieResponse else {return}
                        self.networkManager.getMoviePosterImagesAt(movieResponse.poster_path, completion: {
                            data in
                            movieResponse.poster_image = data
                            self.popularMovies.append(movieResponse)
//                            self.dict[0]?.append(movieResponse)
                            DispatchQueue.main.async {
                                self.moviesCollectionView.reloadData()
                            }
                            
                        })

                    })
                }
            }
        })
    }
}


extension MovieTabBarCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tabSectionSelected == 0 && firstTimePopularMovieCall {
            self.getPopularMovies()
            firstTimePopularMovieCall = false
        } else if tabSectionSelected == 1 && firstTimeNowPlayingMovieCall {
            self.getNowPlayingMovies()
            firstTimeNowPlayingMovieCall = false
        }
        if tabSectionSelected == 0 {
            return popularMovies.count
        } else if tabSectionSelected == 1 {
            return nowPlayingMovies.count
        }
        return 0
//        return dict[tabSectionSelected]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCollectionViewCellIdentifier, for: indexPath) as? MovieCollectionViewCell {
            cell.movieImage.image = nil
            var movieArray:[MovieDetail] = []
            if tabSectionSelected == 0 {
                movieArray = popularMovies
            } else if tabSectionSelected == 1 {
                movieArray = nowPlayingMovies
            }
            if let data = movieArray[indexPath.row].poster_image,
                let poster_image = UIImage(data: data) {
                    cell.movieImage.image = poster_image
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension MovieTabBarCell :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.didTapMovieTabBarCellWith(movieDetail: dict[tabSectionSelected]?[indexPath.row])
        if tabSectionSelected == 0  {
            delegate?.didTapMovieTabBarCellWith(movieDetail: popularMovies[indexPath.row])
        } else if tabSectionSelected == 1  {
            delegate?.didTapMovieTabBarCellWith(movieDetail: nowPlayingMovies[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let tab = dict[tabSectionSelected] {
//            if tabSectionSelected == 0 //&& indexPath.row == tab.count - 1
//            {
//                self.getPopularMovies()
//            }
//            if tabSectionSelected == 1 //&& indexPath.row == tab.count - 1
//            {
//                self.getNowPlayingMovies()
//            }
//        }
        print(tabSectionSelected)
        if tabSectionSelected == 0 && indexPath.row == popularMovies.count - 1 {
            self.getPopularMovies()
        } else if tabSectionSelected == 1 && indexPath.row == nowPlayingMovies.count - 1 {
            self.getNowPlayingMovies()
        }
    }
}

extension MovieTabBarCell : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}
