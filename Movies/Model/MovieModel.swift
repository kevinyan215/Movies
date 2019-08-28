//
//  MovieModel.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import Foundation

struct MovieResultModel: Codable {
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [MovieModel?]
}

struct MovieModel: Codable {
    var vote_count: Int?
    var id: Int?
    var video: Bool?
    var vote_average: Double?
    var title: String?
    var popularity: Double?
    var poster_path: String?
    var original_language: String?
    var original_title: String?
    var genre_ids: [Int?]
    var backdrop_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    
    var poster_image: Data?
}
