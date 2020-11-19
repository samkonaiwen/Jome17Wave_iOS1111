//
//  SurfMapViewController.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/17.
//

import UIKit
import MapKit
import CoreLocation

class SurfMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    var getLocation = false
    var surfPoint = [Map]()
    let url_server = URL(string: common_url + "SURF_POINTServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestWhenInUseAuthorization()
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(SurfAnnotation.self)")
        getMapData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMapData()
//        mapView.reloadInputViews()
    }
    
    func getMapData() {
        var requestParam = [String: Any]()
        requestParam ["action"] = "getAll"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([Map].self, from: data!) {
                        //print("data:\(result)")
                        self.surfPoint = result
                        
//                        let annotations = result.map {
//                            SurfAnnotation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude!, longitude: $0.longitude!))
                        DispatchQueue.main.async {
                            var annotations = [MKPointAnnotation]()
                            for i in 0...(self.surfPoint.count) - 1 {
                                let annotation = MKPointAnnotation()
                                annotation.title = self.surfPoint[i].name
                                annotation.subtitle = self.surfPoint[i].side
                                annotation.coordinate = CLLocationCoordinate2D(latitude: self.surfPoint[i].latitude!, longitude: self.surfPoint[i].longitude!)
                                annotations.append(annotation)
                            }
                            self.mapView.showAnnotations(annotations, animated: true)
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
}

extension SurfMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if getLocation == false {
            getLocation = true
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 400000)
            
            mapView.setRegion(region, animated: true)
            
        }
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard let annotation = annotation as? SurfAnnotation else { return nil}
//
//        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "\(SurfAnnotation.self)", for: annotation)
//
//        annotationView.canShowCallout = true
//
//        return annotationView
//    }

//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let annotation = view.annotation as? SurfAnnotation
//    }
    
}
