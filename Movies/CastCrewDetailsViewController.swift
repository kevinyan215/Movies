//
//  CastCrewDetailsViewController.swift
//  Movies
//
//  Created by Kevin Yan on 7/28/21.
//  Copyright © 2021 Kevin Yan. All rights reserved.
//

import UIKit

class CastCrewDetailsViewController : UIViewController	 {
    var creditId: String?
    var knownFor: [MovieDetail] = []
    
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
        collectionView.backgroundColor = UIColor.gray
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: movieCollectionViewCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        self.setupViews()
    }
    
    func setupViews() {
        self.getKnownForMovies()

        self.view.addSubview(moviesCollectionView)
        self.setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

        ])
    }
    
    func getKnownForMovies() {
        networkManager.getCastDetails(creditId: creditId ?? "", completionHandler: {
            response, error in
            guard let response = response as? CastDetails else { return }
            DispatchQueue.main.async {
                self.navigationItem.title = response.person?.name ?? ""
            }
            if let movie = response.person?.known_for {
                for movie in movie {
                    networkManager.getMovieDetailAt(movie.id ?? 0, completionHandler:  {
                        movieResponse, error in
                        guard var movieResponse = movieResponse as? MovieDetail else {return}
                        networkManager.getMoviePosterImagesAt(movieResponse.poster_path, completion: {
                            data,error  in
                            movieResponse.poster_image = data
                            self.knownFor.append(movieResponse)
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

extension CastCrewDetailsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return knownFor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCollectionViewCellIdentifier, for: indexPath) as? MovieCollectionViewCell {
            cell.movieImage.image = nil
            if let data = knownFor[indexPath.item].poster_image,
                let poster_image = UIImage(data: data) {
                    cell.movieImage.image = poster_image
            }
            cell.ratingView.configureViewFor(voteAverage: knownFor[indexPath.item].vote_average ?? 0.0)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension CastCrewDetailsViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieDetail = knownFor[indexPath.row]
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension CastCrewDetailsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
