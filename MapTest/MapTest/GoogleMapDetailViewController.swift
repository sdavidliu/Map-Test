//
//  GoogleMapDetailViewController.swift
//  MapTest
//
//  Created by David Liu on 9/12/18.
//  Copyright © 2018 UCI Student Center. All rights reserved.
//

import UIKit
import MapKit

class GoogleMapDetailViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var location: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Lat: \(location.latitude)\nLong: \(location.longitude)"
    }

}
