//
//  PurchaseConfirmation.swift
//  Movies
//
//  Created by Kevin Yan on 6/1/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import Foundation

struct PurchaseConfirmation : Codable {
    let film_id: Int?
    let film_name: String?
    let other_titles: OtherTitles?
    let date: String?
    let time: String?
    let cinema_id: Int?
    let cinema_name: String?
    let movietickets_affiliate: Int?
    let url: String?
    let dl_status: String?
    let status: Status?
}
