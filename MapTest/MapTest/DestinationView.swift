//
//  DestinationView.swift
//  MapTest
//
//  Created by David Liu on 9/11/18.
//  Copyright © 2018 UCI Student Center. All rights reserved.
//

import UIKit
import MapKit

class DestinationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let destination = newValue as? Destination else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton
            //      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = destination.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = destination.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
    
}
