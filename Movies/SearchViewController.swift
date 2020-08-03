//
//  SearchViewController.swift
//  Movies
//
//  Created by Kevin Yan on 5/17/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController {
    
    let searchBar = UISearchBar()
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var searchResults: [SearchResult?] = []
    
    override func viewDidLoad() {
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCellIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lightGray
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(exitSearchBar))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func exitSearchBar() {
        navigationItem.rightBarButtonItem = nil
//        searchBar.text = ""
//        searchBar.placeholder = "Search"
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(exitSearchBar))
        searchBar.placeholder = nil
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchNetworkCallWith(searchText)
    }
    
    func searchNetworkCallWith(_ searchText: String) {
        let searchTextUrlEncoded = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = movieSearchUrl + query + searchTextUrlEncoded
        print(urlString)
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            NetworkingManager.shared.getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                     do {
                        var response = try JSONDecoder().decode(SearchResultList.self, from: data)
                        if response.results.count == 0 {
                            self.searchResults = []
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                        for (index,movieTvShow) in response.results.enumerated() {
                            self.getPosterImageAt(posterPath: movieTvShow?.poster_path, success: {
                                data in
                                response.results[index]?.poster_image = data
                                self.searchResults = response.results
                                DispatchQueue.main.async {
                                   self.tableView.reloadData()
                                }
                            }, failure: {
                                response in
                                print(response)
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

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCellIdentifier, for: indexPath) as? SearchResultsTableViewCell {
            //multisearch
//            if searchResults[indexPath.row]?.media_type == "tv" {
//                cell.movieTitlelabel.text = searchResults[indexPath.row]?.name
//            } else if searchResults[indexPath.row]?.media_type == "movie" {
                cell.movieTitlelabel.text = searchResults[indexPath.row]?.title
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

extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchId = searchResults[indexPath.row]?.id {
            self.getMovieDetailAt(searchId, success: {
                data in
                    if let data = data {
                        do {
                            var movieResponse = try JSONDecoder().decode(MovieDetail.self, from: data)
                            self.getPosterImageAt(posterPath: movieResponse.poster_path, success:
                                {
                                    response in
                                    if let response = response {
                                        movieResponse.poster_image = response
                                        
                                        DispatchQueue.main.async {
                                            let movieDetailViewController = MovieDetailViewController()
                                            movieDetailViewController.movieDetail = movieResponse
                                            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
                                        }
                                    }
                                }, failure: {
                                    response in
                                    print(response)
                                })
                            
                            
                        } catch {print(error)}}}, failure: {
                response in
                print(response)
            })
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension UIViewController {
    func getPosterImageAt(posterPath: String?, success: @escaping (Data?)->Void, failure: @escaping (Error?) -> Void) {
        if let posterPath = posterPath {
            if let posterPathUrl = URL(string: tmdbImageBaseUrl + posterPath) {
                NetworkingManager.shared.getRequest(urlRequest: URLRequest(url: posterPathUrl), success: success, failure: failure)
            }
        }
    }
}
