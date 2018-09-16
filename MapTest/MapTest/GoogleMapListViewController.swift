//
//  GoogleMapListViewController.swift
//  MapTest
//
//  Created by David Liu on 9/13/18.
//  Copyright © 2018 UCI Student Center. All rights reserved.
//

import UIKit

class GoogleMapListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var mainVC: GoogleMapViewController!
    let destinations = ["Location 1","Location 2","Location 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension GoogleMapListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainVC.destination = destinations[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
}

extension GoogleMapListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = destinations[indexPath.row]
        return cell
    }
}
