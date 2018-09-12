//
//  DetailViewController.swift
//  MapTest
//
//  Created by David Liu on 9/11/18.
//  Copyright © 2018 UCI Student Center. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var location: Destination!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let detailString = location.title! + "\n" + location.locationName + "\n" + location.discipline
        self.label.text = detailString
    }

}
