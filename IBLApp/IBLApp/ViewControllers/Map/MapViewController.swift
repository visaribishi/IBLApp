//
//  MapViewController.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var calloutView: CustomCalloutView!
    var annotations: [MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getBankList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        focusOnAnnotations()
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
    }
    
    func focusOnAnnotations() {
        mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        mapView.showAnnotations(self.annotations, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            // Don't proceed with custom callout
            return
        }
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        calloutView = views?[0] as? CustomCalloutView
        if let customAnnotation = view.annotation as? CustomAnnotation {
            calloutView.details = customAnnotation.details
            calloutView.addressLabel.text = customAnnotation.details.address
            calloutView.nameLabel.text = customAnnotation.details.name
        }
        if let callout = calloutView {
            callout.center = CGPoint(x: view.bounds.size.width / 2, y: -callout.bounds.size.height * 0.52)
            view.addSubview(calloutView!)
        }
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.calloutView.removeFromSuperview()
    }
}
