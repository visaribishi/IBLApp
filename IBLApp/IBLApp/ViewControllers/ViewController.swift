//
//  ViewController.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var mapViewController: MapViewController = {
        // Instantiate View Controller
        guard let viewController = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {
            fatalError("MapViewController is missing")
        }
        return viewController
    }()
    
    private lazy var listViewController: ListViewController = {
        // Instantiate View Controller
        guard let viewController = UIStoryboard(name: "List", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else {
            fatalError("ListViewController is missing")
        }
        return viewController
    }()

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(asChildViewController: mapViewController)
    }
    
    @IBAction func myLocationButtonPressed(_ sender: Any) {
        switchToMap()
        mapViewController.focusCurrentLocation()
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        switchToMap()
        mapViewController.focusOnAnnotations()
    }
    
    @IBAction func listButtonPressed(_ sender: Any) {
        switchToList()
    }
    
    func focus(location: Location) {
        switchToMap()
        mapViewController.centerTo(location: location)
    }
    func switchToMap() {
        guard children.first as? MapViewController != nil else {
            remove(asChildViewController: listViewController)
            add(asChildViewController: mapViewController)
            return
        }
    }
    
    func switchToList() {
        guard children.first as? ListViewController != nil else {
            remove(asChildViewController: mapViewController)
            add(asChildViewController: listViewController)
            listViewController.delegate = self
            return
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}

extension ViewController: ListViewControllerDelegate {
    func itemPressed(with location: Location) {
        self.switchToMap()
        self.focus(location: location)
    }
}

