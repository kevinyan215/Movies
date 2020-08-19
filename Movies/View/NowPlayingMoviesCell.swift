//
//  NowPlayingMoviesCell.swift
//  Movies
//
//  Created by Kevin Yan on 8/11/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class NowPlayingMoviesCell : MovieTabBarCell {
    override func fetchMovies() {
        super.fetchMovies()
        networkManager.getNowPlayingMoviesWith(pageNumber: pageNumber, completionHandler: fetchMovieClosure)
    }
}
