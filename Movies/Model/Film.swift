//
//  Film.swift
//  Movies
//
//  Created by Kevin Yan on 5/22/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import Foundation

struct FilmResponse : Codable {
    let films: [Film]?
    let status: Status?
}

struct Status : Codable {
    let count: Int?
    let state: String?
    let method: String?
    let message: String?
    let request_method: String?
    let version: String?
    let territory: String?
    let device_datetime_sent: String?
    let device_datetime_used: String?
}
struct Film : Codable {
    let film_id: Int?
    let imdb_id: Int?
    let imdb_title_id: String?
    let film_name: String?
    let other_titles: OtherTitles?
    let release_dates: [ReleaseDate]?
    let age_rating: [AgeRating]?
    let film_trailer: String?
    let synopsis_long: String?
    let images: Image?
    
    let showings: Showings?
}

struct OtherTitles : Codable {
    let EN: String?
}

struct ReleaseDate : Codable {
    let release_date: String?
    let notes: String?
}

struct AgeRating : Codable {
    let rating: String?
    let age_rating_image: String?
    let age_advisory: String?
}

struct Image : Codable {
    let poster: MovieGuruPoster?
}

struct MovieGuruPoster : Codable {
    let posterDetail: PosterDetails?
}

struct PosterDetails : Codable {
    let image_orientation: String?
    let region: String?
    let medium: String?
}

struct Showings: Codable {
    let Standard: Standard?
}

struct Standard : Codable {
    let film_id: Int?
    let film_name: String?
    let times: [Time]?
}

struct Time : Codable {
    let start_time: String?
    let end_time: String?
}
