//
//  MovieModel.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [Movie?]
}

struct Movie: Codable {

    let vote_count: Int?
    let id: Int?
    let video: Bool?
    let vote_average: Double?
    let title: String?
    let popularity: Double?
    let poster_path: String?
    let original_language: String?
    let original_title: String?
    let genre_ids: [Int?]
    let backdrop_path: String?
    let adult: Bool?
    let overview: String?
    let release_date: String?
}


struct MovieDetail: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let belongs_to_collection: Collection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdb_id: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let production_companies: [ProductionCompany]?
    let production_countries: [ProductionCountry]?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let spoken_languages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
    let videos: Videos?
    let images: Images?
    
    var poster_image: Data?
}

struct Collection: Codable {
    let id: Int?
    let name: String?
    let poster_path: String?
    let backdrop_path: String?
}

struct Genre : Codable {
    let id: Int?
    let name: String?
}

struct ProductionCompany : Codable{
    let id: Int
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

struct ProductionCountry : Codable {
    let iso_3166_1: String?
    let name: String?
}

struct SpokenLanguage : Codable {
    let iso_639_1: String?
    let name: String?
}

struct Videos : Codable {
    let results: [Video]
}

struct Video: Codable {
    let id: String?
    let iso_639_1: String?
    let iso_3166_1: String?
    let key: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
}

struct Images: Codable {
    let backdrops: [Backdrop]?
    let posters:  [Poster]?
}

struct Backdrop: Codable {
    let aspect_ratio: Double?
    let file_path: String?
    let height: Int?
    let iso_639_1: String?
    let vote_average: Double?
    let vote_count: Int?
    let width: Int?
}

struct Poster: Codable {
    let aspect_ratio: Double?
    let file_path: String?
    let height: Int?
    let iso_639_1: String?
    let vote_average: Double?
    let vote_count: Int?
    let width: Int?
}
