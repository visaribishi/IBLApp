//
//  UserAnnotation.swift
//  IBLApp
//
//  Created by Visar on 2/20/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.image = UIImage(named: "ic_pin_user")
    }
}
