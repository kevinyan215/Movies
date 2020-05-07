//
//  CastCrew.swift
//  Movies
//
//  Created by Kevin Yan on 12/5/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import Foundation

class CastCrew: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}

class Cast: Codable {
    let cast_id: Int
    let character: String
    let credit_id: String
    let gender: Int?
    let id: Int
    let name: String
    let order: Int
    let profile_path: String?
    
    var profile_image: Data?
}

class Crew: Codable {
    let credit_id: String
    let department: String
    let gender: Int?
    let id: Int
    let job: String
    let name: String
    let profile_path: String?
    
    var profile_image: Data?
}
