//
//  DestinationMarkerView.swift
//  MapTest
//
//  Created by David Liu on 9/11/18.
//  Copyright © 2018 UCI Student Center. All rights reserved.
//

import UIKit
import MapKit

class DestinationMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let destination = newValue as? Destination else { return }
            canShowCallout = true
            //calloutOffset = CGPoint(x: 0, y: 0)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = destination.markerTintColor
            //      glyphText = String(destination.discipline.first!)
            if let imageName = destination.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
        }
    }
    
}
