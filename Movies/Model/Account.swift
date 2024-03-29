//
//  Account.swift
//  Movies
//
//  Created by Kevin Yan on 8/16/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import Foundation

struct Account: Codable {
    let avatar: Avatar
    let id: Int
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let include_adult: Bool
    let username: String
}

struct Avatar: Codable {
    let gravatar: Gravatar
    let tmdb: TMDB
}

struct Gravatar: Codable {
    let hash: String
}

struct TMDB: Codable {
    let avatar_path: String?
}

struct AccountResponse: Codable {
    let status_code: Int
    let status_message: String
}

struct DeleteSessionResponse: Codable {
    let success: Bool
}
