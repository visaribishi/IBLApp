//
//  CustomAnnotation.swift
//  IBLApp
//
//  Created by Visar on 2/19/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var details: Bank!
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D, details: Bank) {
        self.coordinate = coordinate
        self.details = details
        switch details.type {
        case .atm:
            self.image = UIImage(named: "ic_pin_atm")
        case .branch:
            self.image = UIImage(named: "ic_pin_branch")
        }
    }
}
