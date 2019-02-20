//
//  MapViewController.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit
import MapKit

protocol CalloutDelegate: class {
    func calloutPressed(with data: Bank)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var calloutView: CustomCalloutView!
    var annotations: [MKAnnotation] = []
    var currentLocationAnnotation: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getBankList()
    }
    
    func getBankList() {
        DataManager.shared.getBankList { (result) in
            switch result {
            case .success(let banks):
                self.displayPins(for: banks)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func displayPins(for banks: [Bank]) {
        for bank in banks {
            let location = CLLocationCoordinate2D(latitude: bank.location.lat, longitude: bank.location.long)
            let pin = CustomAnnotation(coordinate: location, details: bank)
            mapView.addAnnotation(pin)
            annotations.append(pin)
        }
        focusOnAnnotations()
    }
    
    func focusOnAnnotations() {
        DispatchQueue.main.async {
            self.mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.mapView.showAnnotations(self.annotations, animated: true)
        }
    }
    
    func focusCurrentLocation() {
        guard let currentLocation = LocationManager.shared.getCurrentLocation() else {
            let alertViewController = UIAlertController(title: "Error getting user location!", message: "Please try again.", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertViewController, animated: true, completion: nil)
            return
        }
        if let currentAnnotation = currentLocationAnnotation {
            mapView.removeAnnotation(currentAnnotation)
        }
        let pin = UserAnnotation(coordinate: currentLocation.coordinate)
        mapView.addAnnotation(pin)
        currentLocationAnnotation = pin
        self.mapView.setCenter(currentLocation.coordinate, animated: true)
    }
    
    // Center bank/branch location from the ListViewController
    func centerTo(location: Location) {
        if let annotation = self.annotations.filter({$0.coordinate.latitude == location.lat && $0.coordinate.longitude == location.long}).first {
            self.mapView.showAnnotations([annotation], animated: true)
        } else {
            let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            self.mapView.setCenter(coordinate, animated: true)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destiontion = segue.destination as? DetailsViewController, let bank = sender as? Bank {
            destiontion.bank = bank
        }
    }
 

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView != nil {
            annotationView?.annotation = annotation
        } else {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        if let customAnnotation = annotation as? CustomAnnotation {
            annotationView?.image = customAnnotation.image
        }
        
        if let userAnnotation = annotation as? UserAnnotation {
            annotationView?.image = userAnnotation.image
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            // Don't proceed with custom callout
            return
        }
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        calloutView = views?[0] as? CustomCalloutView
        if let customAnnotation = view.annotation as? CustomAnnotation, let callout = calloutView {
            calloutView.delegate = self
            calloutView.details = customAnnotation.details
            calloutView.addressLabel.text = customAnnotation.details.address
            calloutView.nameLabel.text = customAnnotation.details.name
            
            callout.center = CGPoint(x: view.bounds.size.width / 2, y: -callout.bounds.size.height * 0.52)
            view.addSubview(calloutView!)
            mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.calloutView.removeFromSuperview()
    }
}

extension MapViewController: CalloutDelegate {
    func calloutPressed(with data: Bank) {
        performSegue(withIdentifier: "goToDetails", sender: data)
    }
}
