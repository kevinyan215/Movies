//
//  Cinema.swift
//  Movies
//
//  Created by Kevin Yan on 5/30/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import Foundation

struct CinemaResponse : Codable {
    let cinemas: [Cinema]?
    let status: Status?
}

struct CinemaDetailResponse : Codable {
    let cinema: Cinema?
    let status: Status?
}

struct Cinema : Codable {
	let cinema_id: Int?
	let cinema_name: String?
	let address: String?
	let address2: String?
	let city: String?
	let state: String?
	let country: String?
//	let postcode: Int?
	var lat: Double?
	var lng: Double?
	let distance: Double?
	let logo_url: String?
    
    let showings: Showings?
    let county: String?
}

struct CinemaShowTimeResponse: Codable {
    let cinema: Cinema?
    let films: [Film]?
    let status: Status?
    
}
