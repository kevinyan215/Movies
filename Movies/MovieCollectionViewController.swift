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
    var movieArray:[MovieModel] = []
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        movieCollectionView.register(UINib(nibName: movieCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: movieCollectionViewCellNibName)
        movieCollectionView.dataSource = self
        
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
        let popularMovieUrl = popularMovieBaseUrl + "\(pageNumber)"
        
        if let url = URL(string: popularMovieUrl) {
            let urlRequest = URLRequest(url: url)
            NetworkingManager.shared.getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(MovieResultModel.self, from: data)
                        self.pageNumber += 1
                        for movie in response.results {
                            if let movie = movie {
                                self.movieArray.append(movie)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.movieCollectionView.reloadData()
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
}

extension MovieCollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == movieArray.count - 1 {
            self.getPopularMovies()
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCollectionViewCellNibName, for: indexPath) as? MovieCollectionViewCell {
            
            if let data = self.movieArray[indexPath.row].poster_image {
                if let poster_image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.movieImage.image = poster_image
                    }
                }
            } else {
                if let posterPath = movieArray[indexPath.row].poster_path {
                    if let posterPathUrl = URL(string: tmdbImageBaseUrl + posterPath) {
                        NetworkingManager.shared.getRequest(urlRequest: URLRequest(url: posterPathUrl), success:{
                            response in
                            if let data = response, let poster_image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    cell.movieImage.image = poster_image
                                    self.movieArray[indexPath.row].poster_image = data
                                }
                            }
                    }, failure:{ response in
                            print(response)
                        })
                    }
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    
}
