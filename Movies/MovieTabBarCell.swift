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

class MovieTabBarCell : BaseCell {
    weak var delegate: MovieTabBarCellDelegate?
    var movies:[MovieDetail] = []
    var pageNumber: Int = 0
    var isWaiting = false

    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let numberOfCellsPerRow: CGFloat = 2
        let horizontalSpacing = layout.scrollDirection == .vertical ? layout.minimumInteritemSpacing : layout.minimumLineSpacing
        let cellWidth = (self.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 40)
        return layout
    }()
    
    lazy var moviesCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: movieCollectionViewCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    func getMovies() {
        self.pageNumber += 1
    }
    
    lazy var getMovieClosure: (Decodable?, Error?) -> Void = {
        response, error in
        guard let response = response as? MovieList else { return }
        for movie in response.results {
            if let movie = movie, let movieId = movie.id {
                networkManager.getMovieDetailAt(movieId, completionHandler:  {
                    movieResponse, error in
                    guard var movieResponse = movieResponse as? MovieDetail else {return}
                    networkManager.getMoviePosterImagesAt(movieResponse.poster_path, completion: {
                        data,error  in
                        movieResponse.poster_image = data
                        self.movies.append(movieResponse)
                        DispatchQueue.main.async {
                            self.moviesCollectionView.reloadData()
                            self.isWaiting = false
                        }
                    })

                })
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.getMovies()

        self.addSubview(moviesCollectionView)
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
}


extension MovieTabBarCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCollectionViewCellIdentifier, for: indexPath) as? MovieCollectionViewCell {
            cell.movieImage.image = nil
            if let data = movies[indexPath.item].poster_image,
                let poster_image = UIImage(data: data) {
                    cell.movieImage.image = poster_image
            }
            cell.ratingView.configureViewFor(voteAverage: movies[indexPath.item].vote_average ?? 0.0)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension MovieTabBarCell :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapMovieTabBarCellWith(movieDetail: movies[indexPath.item])

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == movies.count - 1 && !isWaiting {
            self.getMovies()
            self.isWaiting = true
        }
    }
}

extension MovieTabBarCell : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}
