//
//  MovieTabBarCell.swift
//  Movies
//
//  Created by Kevin Yan on 8/7/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

protocol MovieTabBarCellDelegate : class {
    func didTapMovieTabBarCellWith(movieDetail: MovieDetail)
}

class MovieTabBarCell : UICollectionViewCell {
    weak var delegate: MovieTabBarCellDelegate?
    
    var movieArray:[MovieDetail] = []
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
        
        self.setupConstraints()
        self.getPopularMovies()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 150),
            moviesCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

        ])
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
                            self.movieArray.append(movieResponse)
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
        return movieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCollectionViewCellIdentifier, for: indexPath) as? MovieCollectionViewCell {
            cell.movieImage.image = nil
            if let data = self.movieArray[indexPath.row].poster_image,
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
        delegate?.didTapMovieTabBarCellWith(movieDetail: movieArray[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movieArray.count - 1 {
            self.getPopularMovies()
        }
    }
}

extension MovieTabBarCell : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}
