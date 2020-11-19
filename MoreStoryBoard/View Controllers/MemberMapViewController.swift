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

    @IBOutlet weak var memberMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberMapView.delegate = self
        setMapRegion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMemberData()
        setMapRegion()
    }
    
    func getMemberData() {
        let requestParam = ["action" : "getAllMembers"]
        executeTask(url!, requestParam) { (data, resp, error) in
            if let result = try? JSONDecoder().decode([JomeMember].self, from: data!){

                DispatchQueue.main.async {
                    self.allMembers = result
                    self.members = self.allMembers

                    for i in 0...(self.members.count) - 1 {
                        let annotation = MKPointAnnotation()
                        annotation.title = self.members[i].nickname
                        annotation.coordinate = CLLocationCoordinate2D(latitude: self.members[i].latitude!, longitude: self.members[i].longitude!)
                        self.annotations.append(annotation)
                    }
                    self.memberMapView.showAnnotations(self.annotations, animated: true)
                }
            }
        }
    }
    
    func setMapRegion() {
//        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.8523012, longitude: 120.9009427), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        memberMapView.setRegion(region, animated: true)
//        memberMapView.regionThatFits(region)
    }
}

extension MemberMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}


