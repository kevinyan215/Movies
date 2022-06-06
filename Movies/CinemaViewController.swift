//
//  CinemaViewController.swift
//  Movies
//
//  Created by Kevin Yan on 5/23/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI

class CinemaViewController : UIViewController {
    var filmId: Int?
    var cinemas: [Cinema] = []
    var locationManager:CLLocationManager!
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        return mapView
    }() 


    lazy var currentLocationButton: CLLocationButton = {
        let buttonHeight = 50.0
        let buttonWidth = 50.0
        let button = CLLocationButton(frame: CGRect(x: self.view.frame.size.width - buttonWidth,
                                                    y: (self.view.frame.size.height*0.5),
                                                    width: 50,
                                                    height: buttonHeight))
        
        //y:self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height ?? 0) - buttonHeight - 40
        // button.label = .currentLocation
        button.icon = .arrowFilled
//        button.backgroundColor = .lightB
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(getCurrentLocation), for: .touchDown)
        return button
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NearbyCinemaTableViewCell.self, forCellReuseIdentifier: NearbyCinemaTableViewCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        self.setupView()
        self.setupConstraints()

        getCurrentLocation()
        if let filmId = self.filmId, let currentLocation = self.locationManager.location {
            
            let latLongString: String
            
            if sandboxEnabled {
                latLongString = "-22.68;14.52" //sandbox
            } else {
                latLongString = "\(String(format: "%.2f", currentLocation.coordinate.latitude));\(String(format: "%.2f", currentLocation.coordinate.longitude))" //prod
            }
            
            self.getFilmShowTimes(withFilmId: filmId, latLong: latLongString, date: getCurrentDate())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setupView() {
        self.view.addSubview(mapView)
        self.view.addSubview(currentLocationButton)
        self.view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.mapView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.mapView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height*(1/2)),
            // self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            // self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            // self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),

            self.currentLocationButton.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor, constant: 0),
            self.currentLocationButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -20),
            self.currentLocationButton.widthAnchor.constraint(equalToConstant: 50),
            self.currentLocationButton.heightAnchor.constraint(equalToConstant: 50),

            self.tableView.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 0),
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.tableView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height*(1/2)),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)

        ])
    }


    @objc func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
            if let currentLocation = self.locationManager.location {
                self.mapView.centerToLocation(currentLocation)
            }
        }
    }

    func getFilmShowTimes(withFilmId filmId: Int,
                            latLong: String,
                            date: String) {
        NetworkingManager.shared.getFilmShowTimes(withFilmId: filmId, latLong: latLong, date: date, numberOfResults: 5, success: {
            [weak self] filmShowTimeResponse in
            guard let filmShowTimeResponse = filmShowTimeResponse as? FilmShowTimeResponse else { return }
            self?.cinemas = filmShowTimeResponse.cinemas
            for (index,cinema) in filmShowTimeResponse.cinemas.enumerated() {
                
                if let cinemaId = cinema.cinema_id {
                    self?.getCinemaDetails(withCinemaId: cinemaId, latLong: latLong, success: {
                        lat,long in
                        if index == 0 {
                            if let lat = lat, let long = long {
                                self?.mapView.centerToLocation(CLLocation(latitude: lat, longitude: long))
                            }
                        }
                    })
                }
            }
        }, failure: {
            print($0)
        })
    }
    
    func getCinemaDetails(withCinemaId cinemaId: Int,
                          latLong: String, success: @escaping (Double?,Double?) -> Void) {
        NetworkingManager.shared.getCinemaDetails(withCinemaId: cinemaId, latLong: latLong, success: {
            [weak self] response in
            guard let cinemaDetailResponse = response as? Cinema else {
                return
            }
            if let row = self?.cinemas.firstIndex(where: {$0.cinema_id == cinemaDetailResponse.cinema_id}) {
                self?.cinemas[row].lat = cinemaDetailResponse.lat
                self?.cinemas[row].lng = cinemaDetailResponse.lng
                if let cinema = self?.cinemas[row] {
                    DispatchQueue.main.async {
                        self?.setCinemaMapAnnotation(index: row)
                        success(cinemaDetailResponse.lat,cinemaDetailResponse.lng)
                        self?.tableView.reloadData()
                    
                    }
                }
            }
        }, failure: {
            print($0)
        })
    }
    
    func getNearbyCinema(withLatLong latLong: String, numberOfResults: Int) {
        NetworkingManager.shared.getNearbyCinemas(withLatLong: latLong, numberOfResults: numberOfResults, success: {
            [weak self] response in 
           guard let response = response as? CinemaResponse, let cinemas = response.cinemas else { return }
           self?.cinemas = cinemas
           DispatchQueue.main.async {
//               self?.setCinemaMapAnnotations(lat: Double?, long: Double?)
               self?.tableView.reloadData()
           }
        }, failure: {
            print($0)
        })
    }
    
    func setCinemaMapAnnotation(index: Int) {
        let cinema = self.cinemas[index]
        if let title = cinema.cinema_name, let lat = cinema.lat, let long = cinema.lng {
            var annotation: CinemaPostAnnotation
            if let address = cinema.address {
                annotation = CinemaPostAnnotation(title: title, subtitle: address, index: index, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            } else {
                annotation = CinemaPostAnnotation(title: title, subtitle: "", index: index, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            }
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func setCinemaMapAnnotations(lat: Double?, long: Double?) {
        for (index,_) in self.cinemas.enumerated() {
            self.setCinemaMapAnnotation(index: index)
        }
    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 30000) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, 
        latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension CinemaViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CinemaPostAnnotation else { return nil }
        
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: NearbyCinemasAnnotationViewIdentifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKMarkerAnnotationView(annotation: annotation,
                                          reuseIdentifier: NearbyCinemasAnnotationViewIdentifier)
            view.canShowCallout = true
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CinemaPostAnnotation, let annotationIndex = annotation.index else { return }
        
        self.tableView.selectRow(at: IndexPath(item: annotationIndex, section: 0), animated: true, scrollPosition: .middle)
    }
}

extension CinemaViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Call stopUpdatingLocation() to stop listening for location updates, other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()

//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
        

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

extension CinemaViewController : UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cinemas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NearbyCinemaTableViewCellIdentifier) as? NearbyCinemaTableViewCell {
            cell.cinemaTitle.text = cinemas[indexPath.row].cinema_name
            if let distance = self.cinemas[indexPath.row].distance {
                cell.distanceLabel.text = "\(String(format: "%.2f", distance)) miles"
            }
            cell.cinemaId = cinemas[indexPath.row].cinema_id
            cell.filmId = self.filmId
            cell.parent = self
            cell.cinemaShowTimes = self.cinemas[indexPath.row].showings?.Standard?.times
            return cell
        }
        return UITableViewCell()
    }  
}

extension CinemaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lat = self.cinemas[indexPath.row].lat, let long = self.cinemas[indexPath.row].lng {
            self.mapView.centerToLocation(CLLocation(latitude: lat, longitude: long), regionRadius: 1000)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
