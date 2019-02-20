//
//  LocationManager.swift
//  IBLApp
//
//  Created by Visar on 2/20/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    fileprivate let locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
    }
    
    func refreshLocation() {
        locationManager.requestLocation()
    }
    
    func getCurrentLocation() -> CLLocation? {
        guard let location = locationManager.location else {
            refreshLocation()
            return nil
        }
        return location
    }
}

extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            refreshLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        default:
            print("Location Services error. Please authorize Location Services in Settings")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Nothing to do here as we are using locationManager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied || error.code == .locationUnknown {
            // Location updates are not authorized.
            return
        }
        print("Location Services error")
    }
    
}
