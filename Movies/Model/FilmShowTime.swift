//
//  FilmShowTimeResponse.swift
//  Movies
//
//  Created by Kevin Yan on 6/4/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import Foundation

struct FilmShowTimeResponse : Codable {
    let film: Film?
    let cinemas: [Cinema]
    let status: Status
}
