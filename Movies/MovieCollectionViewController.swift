//
//  ViewController.swift
//  Movies
//
//  Created by Kevin Yan on 4/20/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {
    var tabSelections = ["Popular", "Now Playing"]
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Popular Movies"
        movieCollectionView.register(MovieTabBarCell.self, forCellWithReuseIdentifier: "MovieTabBarCell")
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        self.scrollView.delegate = self
    }
}

extension MovieCollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabSelections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieTabBarCell", for: indexPath) as? MovieTabBarCell {
            cell.delegate = self
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}



extension MovieCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MovieCollectionViewController : MovieTabBarCellDelegate {
    func didTapMovieTabBarCellWith(movieDetail: MovieDetail) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieDetail = movieDetail
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
}
