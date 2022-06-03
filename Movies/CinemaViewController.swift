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
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        return mapView
    }() 


    lazy var currentLocationButton: CLLocationButton = {
        let buttonHeight = 50.0
        let buttonWidth = 50.0
        let button = CLLocationButton(frame: CGRect(x: self.view.frame.size.width - buttonWidth,
                                                    y: self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height ?? 0) - buttonHeight - 40,
                                                    width: 50,
                                                    height: buttonHeight))
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
            self.mapView.heightAnchor.constraint(equalToConstant: self.view.frame.height*(1/3)),
            // self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            // self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            // self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),

            self.currentLocationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.currentLocationButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15),
            self.currentLocationButton.widthAnchor.constraint(equalToConstant: 50),
            self.currentLocationButton.heightAnchor.constraint(equalToConstant: 50),

            self.tableView.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 0),
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.tableView.heightAnchor.constraint(equalToConstant: self.view.frame.height*(2/3)),

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
        }
    }

    func getNearbyCinema(withLatLong latLong: String) {
        NetworkingManager.shared.getNearbyCinemas(withLatLong: latLong, success: {
            [weak self] response in 
           guard let response = response as? CinemaResponse, let cinemas = response.cinemas else { return }
           self?.cinemas = cinemas
           DispatchQueue.main.async {
               self?.tableView.reloadData()
           }
        }, failure: {
            print($0)
        })
    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, 
        latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension CinemaViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latLong = "-22.68;14.52"
//        let userLocation:CLLocation = (locations.last ?? locations[0]) as CLLocation
        let userLocation: CLLocation = CLLocation(latitude: -22.68, longitude: 14.52)
//      let latLong = "\(userLocation.coordinate.latitude);\(userLocation.coordinate.longitude)"
        getNearbyCinema(withLatLong: latLong)
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()

        mapView.centerToLocation(userLocation)
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        

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
            cell.cinemaId = cinemas[indexPath.row].cinema_id
            cell.filmId = self.filmId
            cell.parent = self
            cell.getShowTimes(success: {
                DispatchQueue.main.async {
                    cell.collectionView.reloadData()
                }
            })
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
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
