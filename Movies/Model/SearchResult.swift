//
//  SearchResult.swift
//  Movies
//
//  Created by Kevin Yan on 7/18/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import Foundation

struct SearchResultList: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    var results: [SearchResult?]
}

struct SearchResult : Codable {
    let original_name: String?
    let genre_ids: [Int]?
    let media_type: String?
    let name: String?
    let popularity: Double?
    let origin_country: [String]?
    let vote_count: Int?
    let first_air_date: String?
    let backdrop_path: String?
    let original_language: String?
    let id: Int?
    let vote_average: Double?
    let overview: String?
    let poster_path: String?

    let video: Bool?
    let original_title: String?
    let title: String?
    
    var poster_image: Data?
}
