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
    var image = UIImage(named: "noImage")

    @IBOutlet weak var memberMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberMapView.delegate = self
        
        setMapRegion()
//        memberMapView.setCenter(CLLocationCoordinate2D(latitude: 25.155790, longitude: 121.547742), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setMapRegion()
        getMemberData()

    }
    
    func getMemberData() {
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
                    self.memberMapView.showAnnotations(self.annotations, animated: true)
                }
            }
        }
    }
    
    func setMapRegion() {

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.8523012, longitude: 120.9009427), latitudinalMeters: 20000, longitudinalMeters: 20000)
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
        moveRegion(lat: selectMember.latitude!, lon: selectMember.longitude!)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "annotation"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        if annotationView == nil {
//            /* 使用MKPinAnnotationView會有預設圖針 */
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        }
//
//        var memberIndex = 0
//        for i in 0...(members.count) - 1 {
//            if ((members[i].nickname?.hasPrefix(String((annotation.title)!!))) != nil) {
//                memberIndex = i
//            }
//        }
//
//        var requestParam = [String: Any]()
//        requestParam["action"] = "getImage"
//        requestParam["memberId"] = self.members[memberIndex].memberId
//        requestParam["imageSize"] = memberMapView.frame.width / 10
//        executeTask(url!, requestParam) { (data, resp, error) in
//            if error == nil {
//                if data != nil {
//                    self.image = UIImage(data: data!)
//                }
//                if self.image == nil {
//                    self.image = UIImage(named: "noImage.jpg")
//                }
//                DispatchQueue.main.async {
//                    annotationView?.image = self.image
//                    let height = annotationView?.frame.height
//                    annotationView?.centerOffset = CGPoint(x: 0, y: -(height!) / 2)
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
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


