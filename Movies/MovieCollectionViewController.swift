//
//  ViewController.swift
//  Movies
//
//  Created by Kevin Yan on 4/20/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController, UICollectionViewDataSource {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        
        return searchBar
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCellIdentifier)
        tableView.separatorStyle = .none
    
        return tableView
    }()
    
    var searchResults: [SearchResult?] = []
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var moviesCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .gray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
//        collectionView.contentInset = UIEdgeInsets(top: 200,left: 0,bottom: 0,right: 0)
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
        let tabBar = MovieTabBar(tabSelections: ["Popular", "Top Rated", "Now Playing", "Upcoming"], frame: .zero)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.delegate = self
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = movieTabBar.tabSelections[0]
//        UINavigationBar.appearance().barTintColor = UIColor.gray

//        self.scrollView.delegate = self
    
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        navigationItem.titleView = searchBar

        view.addSubview(tableView)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        view.addSubview(contentView)
        self.contentView.addSubview(self.moviesCollectionView)
        self.contentView.addSubview(movieTabBar)
        
        let paddedStackView = UIStackView(arrangedSubviews: [movieTabBar])
          
        let stackView = UIStackView(arrangedSubviews: [paddedStackView,  moviesCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            paddedStackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
    }
    
    @objc func dismissKeyboard() {
        navigationItem.rightBarButtonItem = nil
        searchBar.resignFirstResponder()
    }
    
    @objc func cancelBarButtonItemClicked() {
        self.dismissKeyboard()
        self.resetTableView()
    }
    
    func resetTableView() {
        searchResults = []
        searchBar.text = ""
        searchBar.placeholder = "Search"
        self.tableView.reloadData()
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
        let spacing = view.safeAreaInsets.top + view.safeAreaInsets.bottom + movieTabBar.frame.height + 60
        return CGSize(width: view.frame.width, height: view.frame.height - spacing)
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

extension MovieCollectionViewController : MovieTabBarDelegate {
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        moviesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension MovieCollectionViewController : MovieTabBarCellDelegate {
    func didTapMovieTabBarCellWith(movieDetail: MovieDetail?) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieDetail = movieDetail
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
}

extension MovieCollectionViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelBarButtonItemClicked))
        searchBar.placeholder = nil
        self.view.bringSubviewToFront(tableView)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.sendSubviewToBack(tableView)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, searchText != "" {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchNetworkCall), object: nil)
            self.perform(#selector(searchNetworkCall), with: nil, afterDelay: 0.5)
        } else {
            self.resetTableView()
        }
    }
    
    @objc func searchNetworkCall() {
        let searchTextUrlEncoded = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = movieSearchUrl + query + searchTextUrlEncoded
        print(urlString)
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            networkManager.request(urlRequest: urlRequest, success: {
                [weak self] data in
                if let data = data {
                     do {
                        var response = try JSONDecoder().decode(SearchResultList.self, from: data)
                        if response.results.count == 0 {
                            self?.searchResults = []
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                        for (index,movieTvShow) in response.results.enumerated() {
                            networkManager.getMoviePosterImagesAt(movieTvShow?.poster_path, completion: {
                                data,error in
                                response.results[index]?.poster_image = data
                                self?.searchResults = response.results
                                DispatchQueue.main.async {
                                   self?.tableView.reloadData()
                                }
                            })
                            
                        }

                        
                     } catch {
                        print(error)
                    }
                }
                
            }, failure: {
                response in
                print(response)
            })
        }
    }
}

extension MovieCollectionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCellIdentifier, for: indexPath) as? SearchResultsTableViewCell {
            //multisearch
//            if searchResults[indexPath.row]?.media_type == "tv" {
//                cell.movieTitlelabel.text = searchResults[indexPath.row]?.name
//            } else if searchResults[indexPath.row]?.media_type == "movie" {
            cell.moviePosterImage.image = nil
            cell.movieTitlelabel.text = nil
            if let title = searchResults[indexPath.row]?.title {
                cell.movieTitlelabel.text = title
            }
            if let data = searchResults[indexPath.row]?.poster_image,
                let poster_image = UIImage(data: data) {
                cell.moviePosterImage.image = poster_image
            }
//            }
            return cell
        }
        return UITableViewCell()
    }
}

extension MovieCollectionViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let searchId = searchResults[indexPath.row]?.id {
            NetworkingManager.shared.getMovieDetailAt(searchId, completionHandler: {
                movieDetailResponse, error  in
                guard var movieDetailResponse = movieDetailResponse as? MovieDetail else { return }
                DispatchQueue.main.async {
                    let movieDetailViewController = MovieDetailViewController()
                    movieDetailViewController.movieDetail = movieDetailResponse
                    self.navigationController?.pushViewController(movieDetailViewController, animated: true)
                }
            })
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

