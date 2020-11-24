//
//  MemberMapViewController.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/19.
//

import UIKit
import MapKit
import CoreLocation

class MemberMapViewController: UIViewController {
    let url = URL(string: "\(common_url)jome_member/LoginServlet")
    var allMembers = [JomeMember]()
    var members = [JomeMember]()
    var annotations = [MKPointAnnotation]()
    var image: UIImage?

    @IBOutlet weak var memberMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberMapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMemberData()

    }
    
    func getMemberData() {
//        let geocoder = CLGeocoder()
        let requestParam = ["action" : "getAllMembers"]
        executeTask(url!, requestParam) { (data, resp, error) in
            if let result = try? JSONDecoder().decode([JomeMember].self, from: data!){
                DispatchQueue.main.async {
                    self.allMembers = result
                    self.members = self.allMembers
                    self.annotations = self.members.map {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude!, longitude: $0.longitude!)
                        annotation.title = $0.nickname
                        return annotation
                    }
                    print("annotations.count: \(self.annotations.count)")
                    self.memberMapView.showAnnotations(self.annotations, animated: true)
                    
                    self.memberMapView.addAnnotations(self.annotations)
                    self.setMapRegion()
//                    for i in 0...(self.members.count) - 1 {
//                        let location = CLLocation(latitude: self.members[i].latitude!, longitude: self.members[i].longitude!)
//                        let nickname = self.members[i].nickname
//                        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//                            if let placemarks = placemarks,
//                               let placemark = placemarks.first{
//                                subtitleStr = "\(placemark.country)\t\(placemark.locality)"
//                            }
//                        }
//                        let annotation = MKPointAnnotation()
//                        annotation.coordinate = location.coordinate
//                        annotation.title = nickname
//                        annotation.subtitle = subtitleStr
//                        print("subtitleStr~~~~~~~~: \(subtitleStr)")
//                        self.annotations.append(annotation)
//                    }

                }
            }
        }
    }
    
    func setMapRegion() {

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.8523012, longitude: 120.9009427), latitudinalMeters: 200000, longitudinalMeters: 200000)
        memberMapView.setRegion(region, animated: true)
        memberMapView.regionThatFits(region)
    }
    

    
}

extension MemberMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationIndex = members.firstIndex(where: { (member) -> Bool in
            return
            (member.nickname?.hasPrefix(String((view.annotation?.title)!!)))!
        }) else { return }
        
        let selectMember = members[annotationIndex]
        
        var requestParam1 = [String: Any]()
        requestParam1 = ["action" : "getImage"]
        requestParam1["memberId"] = self.members[annotationIndex].memberId
        
        requestParam1["imageSize"] = memberMapView.frame.width / 2
        executeTask(url!, requestParam1) { (data, resp, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = nil
                    self.image = UIImage(data: data)
                    self.moveRegion(lat: selectMember.latitude!, lon: selectMember.longitude!)
                }
            }
        }
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let identifier = "annotation"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        if annotationView == nil {
//            /* 使用MKPinAnnotationView會有預設圖針 */
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        }
//        annotationView?.canShowCallout = true
//        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
//        leftIconView.image = self.image
//        annotationView?.leftCalloutAccessoryView = leftIconView
//
//        return annotationView
//    }
    
    

    
    func moveRegion(lat: Double, lon: Double) {
            let region = MKCoordinateRegion(center:
                  CLLocationCoordinate2D(latitude: lat, longitude: lon),
                  latitudinalMeters: 5000, longitudinalMeters: 5000)
            memberMapView.setRegion(region, animated: true)
    }
    
}


