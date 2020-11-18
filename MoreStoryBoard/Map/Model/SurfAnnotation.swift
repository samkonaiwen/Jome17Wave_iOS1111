//
//  SurfAnnotation.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/18.
//

import MapKit

class SurfAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var surf: Map?
    var title: String? {
        surf?.name
    }
    
    var subtitle: String? {
        "地區: \(surf?.side ?? "")"
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
