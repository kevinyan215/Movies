//
//  ViewController.swift
//  Movies
//
//  Created by Kevin Yan on 4/20/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    var movieArray:[MovieDetail] = []
//    var filteredResuls
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Discover"
        movieCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: movieCollectionViewCellIdentifier)

        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        self.scrollView.delegate = self
//        movieCollectionView.prefetchDataSource = self
        
        self.setCollectionViewLayout()
        getPopularMovies()
    }
    
    func setCollectionViewLayout() {
        let numberOfCellsPerRow: CGFloat = 3
        if let flowLayout = movieCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    func getPopularMovies() {
        if let url = URL(string: movieBaseUrl + popularMovieQuery + APIKey + "&page=" + String(pageNumber)) {
            let urlRequest = URLRequest(url: url)
            NetworkingManager.shared.getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(PopularMovies.self, from: data)
                        self.pageNumber += 1
                        for movie in response.results {
                            if let movie = movie, let movieId = movie.id {
                                self.getMovieDetailAt(movieId, success: {
                                    data in
                                        if let data = data {
                                            do {
                                                var movieResponse = try JSONDecoder().decode(MovieDetail.self, from: data)
                                                
                                                if let posterPath = movieResponse.poster_path {
                                                    if let posterPathUrl = URL(string: tmdbImageBaseUrl + posterPath) {
                                                        NetworkingManager.shared.getRequest(urlRequest: URLRequest(url: posterPathUrl), success:{
                                                            response in
                                                            if let response = response {
                                                                movieResponse.poster_image = response
                                                                self.movieArray.append(movieResponse)
                                                            }
                                                            
                                                            DispatchQueue.main.async {
                                                                self.movieCollectionView.reloadData()
                                                            }
                                                            
                                                        }, failure:{ response in
                                                            print(response)
                                                        })
                                                    }
                                                }
                                                
                                            } catch {print(error)}}}, failure: {
                                                result in print(result)
                                            })
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }, failure: {
                result in print(result)
            })
        }
    }
    
    func getMovieDetailAt(_ movieId: Int, success: @escaping (Data?)->Void, failure: @escaping (Error?) -> Void) {
        let movieIdQuery = "\(movieId)?"
        if let url = URL(string: movieBaseUrl + movieIdQuery + APIKey + "&append_to_response=videos,images" ) {
            let urlRequest = URLRequest(url: url)
            NetworkingManager.shared.getRequest(urlRequest: urlRequest, success: success, failure: failure)
        }
    }
    
}

extension MovieCollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == movieArray.count {
//            self.getPopularMovies()
//        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCollectionViewCellIdentifier, for: indexPath) as? MovieCollectionViewCell {
            if let data = self.movieArray[indexPath.row].poster_image {
                if let poster_image = UIImage(data: data) {
                    cell.movieImage.image = poster_image
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension MovieCollectionViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieDetail = movieArray[indexPath.row]
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension MovieCollectionViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}

extension MovieCollectionViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height;
        let scrollContentSizeHeight = scrollView.contentSize.height;
        let scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset == 0)
        {
            // then we are at the top
        }
        else if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight)
        {
            // then we are at the end
            self.getPopularMovies()
        }
    }
    
    
}
