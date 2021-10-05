//
//  Session.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import Foundation

struct Session : Codable {
    let success: Bool
    let failure: Bool?
    let session_id: String?
    let status_code: Int?
    let status_message: String?
}
