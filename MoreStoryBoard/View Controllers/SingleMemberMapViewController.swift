//
//  SingleMemberMapViewController.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/22.
//

import UIKit
import MapKit
import CoreLocation

class SingleMemberMapViewController: UIViewController {
    @IBOutlet weak var singleMapView: MKMapView!
    
    var member: JomeMember?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        singleMapView.delegate = self
        
        guard let member = self.member else { return }
        
        let location = CLLocation(latitude: member.latitude!, longitude: member.longitude!)
        let geocoder = CLGeocoder()
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = member.nickname
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks,
               let placemark = placemarks.first{
                annotation.subtitle = "\(placemark.subAdministrativeArea ?? "unknow") \(placemark.thoroughfare ?? "unknow")"
            }
        }
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: member.latitude!, longitude: member.longitude!), latitudinalMeters: 2000, longitudinalMeters: 2000)
        self.singleMapView.addAnnotation(annotation)
        self.singleMapView.selectAnnotation(annotation, animated: true)
        self.singleMapView.setRegion(region, animated: true)
        
        
        
    }
}

extension SingleMemberMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            /* 使用MKPinAnnotationView會有預設圖針 */
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.canShowCallout = true
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        leftIconView.image = self.image
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }
    
}
