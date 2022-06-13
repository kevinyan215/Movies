//
//  CinemaPostAnnotation.swift
//  Movies
//
//  Created by Kevin Yan on 6/6/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import MapKit

class CinemaPostAnnotation : NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var index: Int?
    
    init(title : String , subtitle : String , index: Int, coordinate : CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.index = index
        self.coordinate = coordinate
    }
}
