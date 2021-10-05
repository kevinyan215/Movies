//
//  Cast.swift
//  Movies
//
//  Created by Kevin Yan on 7/28/21.
//  Copyright © 2021 Kevin Yan. All rights reserved.
//

import Foundation

class CastDetails : Codable {
    let credit_type: String?
    let department: String?
    let job: String?
    let media: Media?
    let media_type: String?
    let id: String?
    let person: Person?
}

class Media : Codable {
    let poster_path: String?
    let vote_count: Int?
    let video: Bool?
    let vote_average: Double?
    let overview: String?
    let release_date: String?
    let title: String?
    let adult: Bool?
    let backdrop_path: String?
    let genre_ids : [Int]?
    let id: Int?
    let original_language: String?
    let original_title: String?
    let popularity: Double?
    let character: String?
}

class Person : Codable {
    let adult: Bool?
    let gender: Int?
    let name: String?
    let id: Int?
    let known_for: [KnownFor]?
    let known_for_department: String?
    let profile_path: String?
    let popularity: Double?
}

class KnownFor : Codable {
    let backdrop_path: String?
    let genre_ids: [Int]?
    let original_language: String?
    let original_title: String?
    let poster_path: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
    let overview: String?
    let release_date: String?
    let title: String?
    let id: Int?
    let adult: Bool?
    let popularity: Double?
    let media_type: String?
}
