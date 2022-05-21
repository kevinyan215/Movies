//
//  SearchViewController.swift
//  Movies
//
//  Created by Kevin Yan on 5/17/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController {
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
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
        
        view.addSubview(tableView)
        view.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCellIdentifier)
        tableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
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

extension SearchViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelBarButtonItemClicked))
        searchBar.placeholder = nil
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, searchText != "" {
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchNetworkCall), object: nil)
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

extension SearchViewController : UITableViewDelegate {
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
