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
    let networkManager = NetworkingManager()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        let font = UIFont(name: "Helvetica", size: 20.0)
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 3
//        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.allowsDefaultTighteningForTruncation = true
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let plotSummaryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 30
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    
    let runtimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Runtime"
        return label
    }()
    
    let runtimeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let budgetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Budget"
        return label
    }()
    
    let budgetDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let revenueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Revenue"
        return label
    }()
    
    let revenueDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 130, height: 150)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    
    lazy var videoCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var castCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    lazy var crewCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    func setupView() {
        contentView.backgroundColor = UIColor.gray
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(plotSummaryDescriptionLabel)
        contentView.addSubview(runtimeLabel)
        contentView.addSubview(runtimeDescriptionLabel)
        contentView.addSubview(budgetLabel)
        contentView.addSubview(budgetDescriptionLabel)
        contentView.addSubview(revenueLabel)
        contentView.addSubview(revenueDescriptionLabel)
        
        contentView.addSubview(videoCollectionView)
        contentView.addSubview(castCollectionView)
        contentView.addSubview(crewCollectionView)
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
    }
    
    func setupConstraints() {
        let collectionViewHeight: CGFloat = 170.0
        let leadingAnchorSpacing: CGFloat = 20.0
        let collectionViewsleadingAnchorSpacing: CGFloat = 15.0
        let trailingAnchorSpacing: CGFloat = -20.0
        let topBottomSpacingMovieFacts: CGFloat = 0.0
        let widthSpacingMovieFactLabel : CGFloat = 75
        let heightSpacingMovieFactLabel: CGFloat = 50
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: leadingAnchorSpacing),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            posterImage.heightAnchor.constraint(equalToConstant: 100),
            posterImage.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            genreLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            
            releaseDateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            
            plotSummaryDescriptionLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 30),
            plotSummaryDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingAnchorSpacing),
            plotSummaryDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            
            videoCollectionView.topAnchor.constraint(equalTo: plotSummaryDescriptionLabel.bottomAnchor, constant: 30),
            videoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: collectionViewsleadingAnchorSpacing),
            videoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            videoCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

            castCollectionView.topAnchor.constraint(equalTo: videoCollectionView.bottomAnchor, constant: 20),
            castCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: collectionViewsleadingAnchorSpacing),
            castCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            castCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            
            crewCollectionView.topAnchor.constraint(equalTo: castCollectionView.bottomAnchor, constant: 20),
            crewCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: collectionViewsleadingAnchorSpacing),
            crewCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            crewCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            
            runtimeLabel.topAnchor.constraint(equalTo: crewCollectionView.bottomAnchor, constant: 20),
            runtimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingAnchorSpacing),
            runtimeLabel.widthAnchor.constraint(equalToConstant: widthSpacingMovieFactLabel),
            runtimeLabel.heightAnchor.constraint(equalToConstant: heightSpacingMovieFactLabel),
            
            runtimeDescriptionLabel.topAnchor.constraint(equalTo: crewCollectionView.bottomAnchor, constant: 20),
            runtimeDescriptionLabel.leadingAnchor.constraint(equalTo: runtimeLabel.trailingAnchor, constant: 5),
            runtimeDescriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            runtimeDescriptionLabel.heightAnchor.constraint(equalToConstant: heightSpacingMovieFactLabel),
            
            budgetLabel.topAnchor.constraint(equalTo: runtimeLabel.bottomAnchor, constant: topBottomSpacingMovieFacts),
            budgetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingAnchorSpacing),
            budgetLabel.widthAnchor.constraint(equalToConstant: widthSpacingMovieFactLabel),
            budgetLabel.heightAnchor.constraint(equalToConstant: heightSpacingMovieFactLabel),
            
            budgetDescriptionLabel.topAnchor.constraint(equalTo: runtimeDescriptionLabel.bottomAnchor, constant: topBottomSpacingMovieFacts),
            budgetDescriptionLabel.leadingAnchor.constraint(equalTo: budgetLabel.trailingAnchor, constant: 5),
            budgetDescriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            budgetDescriptionLabel.heightAnchor.constraint(equalToConstant: heightSpacingMovieFactLabel),
            
            revenueLabel.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: topBottomSpacingMovieFacts),
            revenueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingAnchorSpacing),
            revenueLabel.widthAnchor.constraint(equalToConstant: widthSpacingMovieFactLabel),
            revenueLabel.heightAnchor.constraint(equalToConstant: heightSpacingMovieFactLabel),
            
            revenueDescriptionLabel.topAnchor.constraint(equalTo: budgetDescriptionLabel.bottomAnchor, constant: topBottomSpacingMovieFacts),
            revenueDescriptionLabel.leadingAnchor.constraint(equalTo: budgetLabel.trailingAnchor, constant: 5),
            revenueDescriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            revenueDescriptionLabel.heightAnchor.constraint(equalToConstant: heightSpacingMovieFactLabel),
            revenueDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        setupView()
        setupConstraints()
        
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
            networkManager.getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        self.castCrew = try JSONDecoder().decode(CastCrew.self, from: data)
                        
                        //TODO
                        if let cast = self.castCrew?.cast {
                            for actor in cast {
                                if let profilePathUrl = actor.profile_path {
                                    if let url = URL(string: tmdbImageBaseUrl + profilePathUrl) {
                                        self.networkManager.getRequest(urlRequest: URLRequest(url: url), success: { data in
                                            actor.profile_image = data
                                            
                                            DispatchQueue.main.async {
                                                self.castCollectionView.reloadData()
                                            }
                                            
                                        }, failure: { error in
                                            print(error)
                                        })
                                    }
                                }
                            }
                            if let crew = self.castCrew?.crew {
                                for member in crew {
                                    
                                    if let profilePathUrl = member.profile_path {
                                        if let url = URL(string: tmdbImageBaseUrl + profilePathUrl) {
                                            self.networkManager.getRequest(urlRequest: URLRequest(url: url), success: { data in
                                                member.profile_image = data
                                                
                                                DispatchQueue.main.async {
                                                    self.crewCollectionView.reloadData()
                                                }
                                                
                                            }, failure: { error in
                                                print(error)
                                            })
                                        }
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
                if castCount > 10 {
                    return 10
                }
                return castCount
            }
        } else if collectionView == crewCollectionView {
            if let crewCount = castCrew?.crew.count {
                if crewCount > 10 {
                    return 10
                }
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
                cell.nameTitleLabel.text = nil
                cell.subTitleLabel.text = nil
                cell.imageView.image = nil
                if let cast = self.castCrew?.cast[indexPath.row] {
                    cell.nameTitleLabel.text = cast.name
                    cell.subTitleLabel.text = cast.character
                    if let imageData = cast.profile_image,
                        let image = UIImage(data: imageData) {
                            cell.imageView.image = image
                        
                    }
                }
                return cell
            }
        } else if collectionView == crewCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: castCrewCollectionViewCellIdentifier, for: indexPath) as? CastCrewCollectionViewCell {
                cell.nameTitleLabel.text = nil
                cell.subTitleLabel.text = nil
                cell.imageView.image = nil
                if let crew = self.castCrew?.crew[indexPath.row] {
                    cell.nameTitleLabel.text = crew.name
                    cell.subTitleLabel.text = crew.job
                    if let imageData = crew.profile_image,
                        let image = UIImage(data: imageData) {
                            cell.imageView.image = image
                        
                    }
                }
                return cell
            }
        }
       
        return UICollectionViewCell()
    }
}
