//
//  LocationManager.swift
//  GoscaleAsignment
//
//  Created by TapashM on 14/07/18.
//  Copyright © 2018 ITC Infotech. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject{
    
    var locationManager : CLLocationManager = CLLocationManager()
    var currentLocation:CLLocation?
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        let authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(" - - - > Did Update Locations = \(locations[0])")
        let  locationArray = locations as NSArray
        currentLocation = locationArray.lastObject as? CLLocation
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        print(" - - - > Did Update To New Location")
    }
}
