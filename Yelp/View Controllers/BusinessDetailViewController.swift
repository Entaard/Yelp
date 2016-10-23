//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Enta'ard on 10/23/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking

class BusinessDetailViewController: UIViewController {

    let annotationIdentifier = "customAnnotationView"
    
    @IBOutlet weak var mapView: MKMapView!
    
    var business: Business!
    var annotation: MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let lon = business.coordinate?["longitude"] as! CLLocationDegrees
        let lat = business.coordinate?["latitude"] as! CLLocationDegrees
        let centerLocation = CLLocation(latitude: lat, longitude: lon)
        goToCenterLocation(centerLocation)
        addAnnotationAtCoordinate(coordinate: centerLocation.coordinate)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    private func goToCenterLocation(_ location: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    private func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = business.name
        annotation.subtitle = business.address
        mapView.addAnnotation(annotation)
    }
    
}

extension BusinessDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        let imageView = UIImageView()
        var img = UIImage()
        if business.imageURL != nil {
            imageView.setImageWith(business.imageURL!)
            img = imageView.image!
            annotationView?.image = img
            annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            annotationView?.canShowCallout = true
        }

        return annotationView
    }
    
}
