//
//  MovieAccountState.swift
//  Movies
//
//  Created by Kevin Yan on 8/23/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import Foundation

struct MovieAccountState: Codable {
    let id: Int
    let favorite: Bool
//    let rated: Int
    let watchlist: Bool
}

struct Rated: Codable {
    let value: Int?
}
