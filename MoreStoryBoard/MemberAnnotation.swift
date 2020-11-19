//
//  MemberAnnotation.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/19.
//

import Foundation
import MapKit

class MemberAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var member: JomeMember?
    var title: String? {
        member?.nickname
    }
    
    internal init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    
}
