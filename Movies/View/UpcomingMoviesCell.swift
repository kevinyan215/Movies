//
//  UpcomingMoviesCell.swift
//  Movies
//
//  Created by Kevin Yan on 8/11/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class UpcomingMoviesCell : MovieTabBarCell {
    override func fetchMovies() {
        super.fetchMovies()
        networkManager.getUpcomingMoviesWith(pageNumber: pageNumber, completionHandler: fetchMovieClosure)
    }
}
