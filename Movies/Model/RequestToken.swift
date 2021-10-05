//
//  RequestToken.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import Foundation

struct RequestToken : Codable {
    let success: Bool
    let expires_at: String
    let request_token: String
}
