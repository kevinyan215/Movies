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
    var movieArray:[Any] = []
    var pageNumber = 1
    let dispatchGroup = DispatchGroup()
    
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
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=608b8e34a89c818571631096e34773a3&language=en-US&page=\(pageNumber)") as! URL
        let urlRequest = URLRequest(url: url)
        NetworkingManager.shared.getRequest(urlRequest: urlRequest, success: {
            data in
            if let data = data {
                do {
                    if let response = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let result = response["results"] as? [[String:Any]] {
                            self.pageNumber += 1
                            for movie in result {
                                if let posterPath = movie["poster_path"] as? String {
                                    let posterPath = URL(string: tmdbImageBaseUrl + posterPath)
                                    if let posterPathUrl = posterPath {
                                        self.dispatchGroup.enter()
                                        NetworkingManager.shared.getRequest(urlRequest: URLRequest(url: posterPathUrl), success:{ response in
                                            self.movieArray.append(response)
                                            self.dispatchGroup.leave()
                                        }
                                            , failure: { response in
                                                print(response)
                                                self.dispatchGroup.leave()
                                        })
                                    }
                                }
                            }
                            
                            self.dispatchGroup.notify(queue: .main, execute: {
                                self.movieCollectionView.reloadData()
                                })
                        }
                        
                    }
                } catch {
                    
                }
            }
        }, failure: {
            result in print(result)
        })
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
            cell.movieImage.image = UIImage(data: movieArray[indexPath.row] as! Data)
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    
}
