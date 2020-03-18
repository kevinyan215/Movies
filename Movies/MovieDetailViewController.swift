//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Kevin Yan on 10/17/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit
import WebKit

class MovieDetailViewController : UIViewController {
    var movieDetail: MovieDetail?
    var castCrew: CastCrew?
    
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var plotSummaryDescriptionLabel: UILabel!
    @IBOutlet weak var runtimeDescriptionLabel: UILabel!
    @IBOutlet weak var budgetDescriptionLabel: UILabel!
    @IBOutlet weak var revenueDescriptionLabel: UILabel!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var crewCollectionView: UICollectionView!

    override func viewDidLoad() {
        self.navigationItem.title = movieDetail?.original_title
        self.videoCollectionView.dataSource = self
        self.castCollectionView.dataSource = self
        self.crewCollectionView.dataSource = self
        
        self.videoCollectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: videoCollectionViewCellIdentifier)
        self.castCollectionView.register(CastCrewCollectionViewCell.self, forCellWithReuseIdentifier: castCrewCollectionViewCellIdentifier)
        self.crewCollectionView.register(CastCrewCollectionViewCell.self, forCellWithReuseIdentifier: castCrewCollectionViewCellIdentifier)

        if let data = self.movieDetail?.poster_image {
            if let poster_image = UIImage(data: data) {
                self.posterImage.image = poster_image
            }
        }
        
        self.titleLabel.text = movieDetail?.title
//        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.releaseDateLabel.text = movieDetail?.release_date
//        self.genreLabel.text = viewModel.g
        self.plotSummaryDescriptionLabel.text = movieDetail?.overview
//        self.plotSummaryDescriptionLabel.adjustsFontSizeToFitWidth = true
        
        var genresString: String = ""
        if let genres = movieDetail?.genres {
            //need to write xctest cases to make sure works properly - empty array, one genre, etc.
//            let testGenres:[String] = []
//            for genre in testGenres {
//
//                    let string = genre + ", "
//                    genresString.append(string)
//
//            }
            
            for genre in genres {
                if let name = genre.name {
                    let string = name + ", "
                    genresString.append(string)
                }
            }
            genresString = String(genresString[..<(genresString.lastIndex(of: ",") ?? genresString.endIndex)])

        }
        genreLabel.text = genresString
        
        if let runtime = movieDetail?.runtime {
            self.runtimeDescriptionLabel.text = "\(runtime) minutes"
        }
        
        let numberFormatter = NumberFormatter.init()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        
        if let budget = movieDetail?.budget {
            self.budgetDescriptionLabel.text = numberFormatter.string(for: budget)
        }
        
        if let revenue = movieDetail?.revenue {
            self.revenueDescriptionLabel.text = numberFormatter.string(for: revenue)
        }
    
        if let movieId = movieDetail?.id, let url = URL(string: movieBaseUrl + "\(movieId)/credits?" + APIKey) {
            let urlRequest = URLRequest(url: url)
            NetworkingManager().getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        self.castCrew = try JSONDecoder().decode(CastCrew.self, from: data)
                        
                        //TODO
                        if let cast = self.castCrew?.cast {
                            for actor in cast {
                                if let profilePathUrl = actor.profile_path {
                                    if let url = URL(string: tmdbImageBaseUrl + profilePathUrl) {
                                        NetworkingManager.shared.getRequest(urlRequest: URLRequest(url: url), success: { data in
                                            actor.profile_image = data
                                            
                                            DispatchQueue.main.async {
                                                self.castCollectionView.reloadData()
                                                self.crewCollectionView.reloadData()
                                            }
                                            
                                        }, failure: { error in
                                            print(error)
                                        })
                                    }
                                }
                            }
                        }
                    } catch {
                        
                    }
                }
            }, failure: { error in
                print(error)
            })
            

        }
        
        
    }
}

extension MovieDetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videoCollectionView {
            if let videoCount = movieDetail?.videos?.results.count {
                return videoCount
            }
        } else if collectionView == castCollectionView {
            if let castCount = castCrew?.cast.count {
                return castCount
            }
        } else if collectionView == crewCollectionView {
            if let crewCount = castCrew?.crew.count {
                return crewCount
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videoCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCollectionViewCellIdentifier, for: indexPath) as? VideoCollectionViewCell {
                if let youtubeVideoUrlKey = movieDetail?.videos?.results[indexPath.row].key,
                    let url = URL(string: YoutubeWatchUrl + youtubeVideoUrlKey)
                {
                    cell.loadVideoFrom(URLRequest(url: url))
                }
                cell.videoTitle.text = movieDetail?.videos?.results[indexPath.row].name
                return cell
            }
        } else if collectionView == castCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: castCrewCollectionViewCellIdentifier, for: indexPath) as? CastCrewCollectionViewCell {
                if let cast = self.castCrew?.cast[indexPath.row] {
                    cell.nameTitleLabel.text = cast.name
                    cell.subTitleLabel.text = cast.character
                    if let imageData = cast.profile_image {
                        if let image = UIImage(data: imageData) {
                            cell.imageView.image = image
                        }
                    }
                }
                return cell
            }
        } else if collectionView == crewCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: castCrewCollectionViewCellIdentifier, for: indexPath) as? CastCrewCollectionViewCell {
                if let crew = self.castCrew?.crew[indexPath.row] {
                    cell.nameTitleLabel.text = crew.name
                    cell.subTitleLabel.text = crew.job
                }
                return cell
            }
        }
       
        return UICollectionViewCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        <#code#>
//    }
    
    
}
