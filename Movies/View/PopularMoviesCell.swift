//
//  PopularMoviesCell.swift
//  Movies
//
//  Created by Kevin Yan on 8/11/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class PopularMoviesCell : MovieTabBarCell {
    override func fetchMovies() {
        networkManager.getPopularMovies(completion: fetchMovieClosure)
    }
}
