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
    var similarMovies: [MovieDetail] = []
    
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

    let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buyTicketsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.setAttributedTitle(NSAttributedString(string: "Buy Tickets",
                                                     attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]),
                                  for: .normal)
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.configuration = buttonConfig
        button.addTarget(self, action: #selector(buyTicketsButtonClicked), for: .touchDown)
        return button
    }()
    
    @objc func buyTicketsButtonClicked() {
        let cinemaViewController = CinemaViewController()
        cinemaViewController.filmId = self.movieDetail?.film_id
        self.navigationController?.pushViewController(cinemaViewController, animated: true)
        print("buyTicketsButtonClicked")
    }
    
    let plotSummaryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 30
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let videoCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 130, height: 200)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    let castCollectionViewFlowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
    //        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: 130, height: 200)
            layout.scrollDirection = .horizontal
            return layout
        }()
    
    let crewCollectionViewFlowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
    //        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: 130, height: 200)
            layout.scrollDirection = .horizontal
            return layout
        }()
    
    let similarMoviesCollectionViewFlowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
    //        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: 130, height: 200)
            layout.scrollDirection = .horizontal
            return layout
        }()
    
    lazy var videoCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: videoCollectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var castCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: castCollectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    lazy var crewCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: crewCollectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let similarMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Similar Movies"
        return label
    }()
    
    lazy var similarMoviesCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: similarMoviesCollectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
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
    
    lazy var watchListBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "watchlist_icon"), style: .plain, target: self, action: #selector(watchListBarButtonClicked))
        return item
    }()
    
    lazy var favoriteBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "unfilled_star_icon"), style: .plain, target: self, action: #selector(favoriteBarButtonClicked))
        return item
    }()
    
    lazy var shareBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBarButtonItemClicked))
        return item
    }()
    
    var isFavoriteList: Bool = false {
        didSet {
            if isFavoriteList {
                DispatchQueue.main.async {
                    self.favoriteBarButtonItem.image = UIImage(named: "filled_star_icon")
                }
            } else {
                DispatchQueue.main.async {
                    self.favoriteBarButtonItem.image = UIImage(named: "unfilled_star_icon")
                }
            }
        }
    }
    
    var isWatchList: Bool = false {
        didSet {
            if isWatchList {
                DispatchQueue.main.async {
                    self.watchListBarButtonItem.tintColor = .blue
                }
            } else {
                DispatchQueue.main.async {
                    self.watchListBarButtonItem.tintColor = .none
                }
            }
        }
    }
    
    override func viewDidLoad() {
        setupView()
        setupConstraints()
        
        self.navigationItem.title = movieDetail?.original_title

        
        self.videoCollectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: videoCollectionViewCellIdentifier)
        self.castCollectionView.register(CastCrewCollectionViewCell.self, forCellWithReuseIdentifier: castCrewCollectionViewCellIdentifier)
        self.crewCollectionView.register(CastCrewCollectionViewCell.self, forCellWithReuseIdentifier: castCrewCollectionViewCellIdentifier)
        self.similarMoviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: SimilarMovieCollectionViewCellIdentifer)
        
        self.titleLabel.text = movieDetail?.title
//        self.titleLabel.adjustsFontSizeToFitWidth = true
        if let date = getDateFromString(date: movieDetail?.release_date ?? "", withFormat: "yyyy-MM-dd") {
            self.releaseDateLabel.text = getStringFromDate(date, withFormat: "MM/dd/yyyy")
        }
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
        
        ratingLabel.text = String(self.movieDetail?.vote_average ?? 0.0)
        
        if let runtime = movieDetail?.runtime {
            self.runtimeDescriptionLabel.text = "\(runtime) minutes"
        }
        
        let numberFormatter = NumberFormatter.init()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        
        if let budget = movieDetail?.budget, budget != 0 {
            self.budgetDescriptionLabel.text = numberFormatter.string(for: budget)
        } else {
            self.budgetDescriptionLabel.text = "N/A"
        }
        
        if let revenue = movieDetail?.revenue, revenue != 0 {
            self.revenueDescriptionLabel.text = numberFormatter.string(for: revenue)
        } else {
            self.revenueDescriptionLabel.text = "N/A"
        }
        
        getMoviePosterImage()
        getCastAndCrew()
        getMovieAccountState()
        getSimilarMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userIsSignedIn() {
            addShareFavoriteWatchListBarButtonItems()
        } else {
            addShareBarButtonItem()
        }
    }
    
    private func getSimilarMovies() {
        guard let movieId = self.movieDetail?.id else { return }
        networkManager.getSimilarMoviesFor(movieId: movieId, success: {
            [weak self] response in
            
            guard let response = response as? MovieList else { return }
            for movie in response.results {
                if let movie = movie, let movieId = movie.id {
                    networkManager.getMovieDetailAt(movieId, completionHandler:  {
                        movieResponse, error in
                        guard var movieResponse = movieResponse as? MovieDetail else {return}
                        networkManager.getMoviePosterImagesAt(movieResponse.poster_path, completion: {
                            data,error  in
                            movieResponse.poster_image = data
                            self?.similarMovies.append(movieResponse)
                            DispatchQueue.main.async {
                                self?.similarMoviesCollectionView.reloadData()
                            }
                        })

                    })
                }
            }
            
        }, failure: {
            error in
        })
        
    }
    
    private func getMovieAccountState() {
        guard let movieId = self.movieDetail?.id else { return }
        networkManager.getMovieStateFor(movieId: movieId, success: {
            [weak self] response in
            guard let response = response as? MovieAccountState else { return }
            self?.isFavoriteList = response.favorite
            self?.isWatchList = response.watchlist
        }, failure: {
            error in
            print(error)
        })
    }
    
    @objc private func shareBarButtonItemClicked() {
        var shareText = "Check out this movie! "
        if let videoCount = movieDetail?.videos?.results.count, videoCount > 0, let videoUrl = movieDetail?.videos?.results[0].key {
            shareText.append(YoutubeWatchUrl + videoUrl)
        } else if let title = movieDetail?.title {
            shareText.append(title)
        }
        
        let activityViewController = UIActivityViewController(activityItems: [shareText],
                                                              applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func addShareFavoriteWatchListBarButtonItems() {
        navigationItem.rightBarButtonItems = [shareBarButtonItem,watchListBarButtonItem,favoriteBarButtonItem]
    }
    
    private func addShareBarButtonItem() {
        navigationItem.rightBarButtonItems = [shareBarButtonItem]
    }
    
    @objc private func favoriteBarButtonClicked() {
        if let movieId = movieDetail?.id {
            networkManager.postFavoriteFor(mediaId: movieId, onFavoriteList: !self.isFavoriteList, success: {
                [weak self] response in
                self?.getMovieAccountState()
            }, failure: {
                [weak self] error in
                self?.getMovieAccountState()
            })
        }
    }
    
    @objc private func watchListBarButtonClicked() {
        if let movieId = movieDetail?.id {
            networkManager.postWatchListFor(mediaId: movieId, onWatchList: !self.isWatchList, success: {
                [weak self] response in
                self?.getMovieAccountState()
        }, failure: {
                [weak self] error in
                self?.getMovieAccountState()
            })
        }
    }
    
    private func getCastAndCrew() {
        if let movieId = movieDetail?.id, let url = URL(string: movieBaseUrl + "\(movieId)/credits?" + APIKey) {
            let urlRequest = URLRequest(url: url)
            networkManager.request(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        self.castCrew = try JSONDecoder().decode(CastCrew.self, from: data)
                        
                        //TODO
                        if let cast = self.castCrew?.cast {
                            for actor in cast {
                                if let profilePathUrl = actor.profile_path {
                                    if let url = URL(string: tmdbImageBaseUrl + profilePathUrl) {
                                        networkManager.request(urlRequest: URLRequest(url: url), success: {
                                            [weak self] data in
                                            actor.profile_image = data
                                            
                                            DispatchQueue.main.async {
                                                self?.castCollectionView.reloadData()
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
                                            networkManager.request(urlRequest: URLRequest(url: url), success: {
                                                [weak self] data in
                                                member.profile_image = data
                                                
                                                DispatchQueue.main.async {
                                                    self?.crewCollectionView.reloadData()
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
    
    func getMoviePosterImage() {
        if self.movieDetail?.poster_image != nil {
            getUIImage()
        } else {
            networkManager.getMoviePosterImagesAt(self.movieDetail?.poster_path, completion: {
                response,error in
                self.movieDetail?.poster_image = response
                self.getUIImage()
            })
        }
    }
    
    func getUIImage() {
        if let data = self.movieDetail?.poster_image {
            if let poster_image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImage.image = poster_image
                }
            }
        }
    }
    func setupView() {
        contentView.backgroundColor = UIColor.gray
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingLabel)
        if self.movieDetail?.film_id != nil {
            contentView.addSubview(buyTicketsButton)
        }
        contentView.addSubview(plotSummaryDescriptionLabel)
        
        contentView.addSubview(videoCollectionView)
        contentView.addSubview(castCollectionView)
        contentView.addSubview(crewCollectionView)
        contentView.addSubview(similarMovieLabel)
        contentView.addSubview(similarMoviesCollectionView)
        
        contentView.addSubview(runtimeLabel)
        contentView.addSubview(runtimeDescriptionLabel)
        contentView.addSubview(budgetLabel)
        contentView.addSubview(budgetDescriptionLabel)
        contentView.addSubview(revenueLabel)
        contentView.addSubview(revenueDescriptionLabel)
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.backgroundColor = UIColor.white
        
    }
    
    func setupConstraints() {
        let collectionViewHeight: CGFloat = 200.0
        let leadingAnchorSpacing: CGFloat = 20.0
        let collectionViewsleadingAnchorSpacing: CGFloat = 20.0
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
            posterImage.heightAnchor.constraint(equalToConstant: 180),
            posterImage.widthAnchor.constraint(equalToConstant: 130),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            genreLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            
            releaseDateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            
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

            similarMovieLabel.topAnchor.constraint(equalTo: crewCollectionView.bottomAnchor, constant: 20),
            similarMovieLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingAnchorSpacing),
            similarMovieLabel.widthAnchor.constraint(equalToConstant: 150),
            similarMovieLabel.heightAnchor.constraint(equalToConstant: heightSpacingMovieFactLabel),
            
            similarMoviesCollectionView.topAnchor.constraint(equalTo: similarMovieLabel.bottomAnchor, constant: 0),
            similarMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: collectionViewsleadingAnchorSpacing),
            similarMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingAnchorSpacing),
            similarMoviesCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

            runtimeLabel.topAnchor.constraint(equalTo: similarMoviesCollectionView.bottomAnchor, constant: 20),
            runtimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingAnchorSpacing),
            runtimeLabel.widthAnchor.constraint(equalToConstant: widthSpacingMovieFactLabel),
            runtimeLabel.heightAnchor.constraint(equalToConstant: heightSpacingMovieFactLabel),

            runtimeDescriptionLabel.topAnchor.constraint(equalTo: similarMoviesCollectionView.bottomAnchor, constant: 20),
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
        
        if self.movieDetail?.film_id != nil {
            NSLayoutConstraint.activate([
                buyTicketsButton.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 30),
                buyTicketsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingAnchorSpacing),
                
                plotSummaryDescriptionLabel.topAnchor.constraint(equalTo: buyTicketsButton.bottomAnchor, constant: 30),
            ])
        } else {
            NSLayoutConstraint.activate([
                plotSummaryDescriptionLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 30)
            ])
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
//                if castCount > 10 {
//                    return 10
//                }
                return castCount
            }
        } else if collectionView == crewCollectionView {
            if let crewCount = castCrew?.crew.count {
//                if crewCount > 10 {
//                    return 10
//                }
                return crewCount
            }
        } else if collectionView == similarMoviesCollectionView {
            return self.similarMovies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videoCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCollectionViewCellIdentifier, for: indexPath) as? VideoCollectionViewCell {
                if let youtubeVideoUrlKey = movieDetail?.videos?.results[indexPath.row].key,
                    let url = URL(string: YoutubeEmbedUrl + youtubeVideoUrlKey)
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
                    } else {
                        cell.imageView.image = UIImage(named: "anonymous_profile")
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
                    } else {
                        cell.imageView.image = UIImage(named: "anonymous_profile")
                    }
                }
                return cell
            }
        } else if collectionView == similarMoviesCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCollectionViewCellIdentifer, for: indexPath) as? MovieCollectionViewCell {
                cell.movieImage.image = nil
                if let data = similarMovies[indexPath.item].poster_image,
                    let poster_image = UIImage(data: data) {
                        cell.movieImage.image = poster_image
                }
                cell.ratingView.configureViewFor(voteAverage: similarMovies[indexPath.item].vote_average ?? 0.0)
                return cell            }
        }
       
        return UICollectionViewCell()
    }
}

extension MovieDetailViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == castCollectionView || collectionView == crewCollectionView {
            let castCrewDetailViewController = CastCrewDetailsViewController()
            if collectionView == castCollectionView {
                castCrewDetailViewController.creditId = castCrew?.cast[indexPath.row].credit_id
            } else if collectionView == crewCollectionView {
                castCrewDetailViewController.creditId = castCrew?.crew[indexPath.row].credit_id
            }
            self.navigationController?.pushViewController(castCrewDetailViewController, animated: false)
        }
        else if collectionView == similarMoviesCollectionView {
            let movieDetailViewController = MovieDetailViewController()
            movieDetailViewController.movieDetail = similarMovies[indexPath.row]
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        }
    }
}
