//
//  TopRatedMoviesCell.swift
//  Movies
//
//  Created by Kevin Yan on 8/11/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class TopRatedMoviesCell : MovieTabBarCell {
    override func getMovies() {
        super.getMovies()
        networkManager.getTopRatedWith(pageNumber: pageNumber, completionHandler: getMovieClosure)
    }
}
