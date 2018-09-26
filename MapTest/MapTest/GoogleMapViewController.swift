//
//  GoogleMapViewController.swift
//  MapTest
//
//  Created by David Liu on 9/12/18.
//  Copyright © 2018 UCI Student Center. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class GoogleMapViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var bottomView: UIView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    let defaultLocation = CLLocationCoordinate2D(latitude: 37.325243, longitude: -122.026419)
    var destination = ""
    var zoomLevel: Float = 17.0

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.latitude,
                                              longitude: defaultLocation.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        //mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        view.addSubview(mapView)
        
        bottomView = UIView(frame: CGRect(x: 10, y: self.view.frame.height - 120, width: self.view.frame.width - 20, height: 80))
        bottomView.layer.cornerRadius = 10.0
        bottomView.backgroundColor = UIColor.white
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowRadius = 3
        bottomView.layer.shadowOffset = CGSize(width: 3, height: 3)
        bottomView.layer.shadowOpacity = 0.7
        bottomView.layer.shouldRasterize = true
        bottomView.isHidden = true
        //self.view.addSubview(bottomView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (destination != "") {
            activityIndicator.startAnimating()
            mapView.clear()
            bottomView.isHidden = false
            mapView.settings.myLocationButton = false
            print("Hello: \(currentLocation)")
            if (destination == "Location 1") {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: 37.323276, longitude: -122.023548)
                marker.title = "Location 1"
                marker.snippet = "Cupertino, CA"
                marker.map = mapView
                //getPolylineRoute(from: (currentLocation?.coordinate)!, to: marker.position)
                drawPath(source: (currentLocation?.coordinate)!, destination: marker.position)
            }else if (destination == "Location 2") {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: 37.329274, longitude: -122.027136)
                marker.title = "Location 2"
                marker.snippet = "Cupertino, CA"
                marker.map = mapView
                //getPolylineRoute(from: (currentLocation?.coordinate)!, to: marker.position)
                drawPath(source: (currentLocation?.coordinate)!, destination: marker.position)
            }else if (destination == "Location 3") {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: 37.323372, longitude: -122.036190)
                marker.title = "Location 3"
                marker.snippet = "Cupertino, CA"
                marker.map = mapView
                //getPolylineRoute(from: (currentLocation?.coordinate)!, to: marker.position)
                drawPath(source: (currentLocation?.coordinate)!, destination: marker.position)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! GoogleMapDetailViewController
            detailVC.location = sender as! CLLocationCoordinate2D
        }else if segue.identifier == "listSegue" {
            let listVC = segue.destination as! GoogleMapListViewController
            listVC.mainVC = self
        }
    }
    
    func drawPath(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        let origin = "\(source.latitude),\(source.longitude)"
        let destination = "\(destination.latitude),\(destination.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&sensor=true&mode=walking&key=AIzaSyDFMdC53Ly7LUaQFSrMqXVVOUgKW6XuPyE"
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 3.0
                    polyline.strokeColor = UIColor.blue
                    polyline.map = self.mapView
                    print("yo")
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=walking")!
        print(url)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.activityIndicator.stopAnimating()
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
                            return
                        }
                        
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            let points = dictPolyline?.object(forKey: "points") as? String
                            self.showPath(polyStr: points!)
                            
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                
                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
                                self.mapView!.moveCamera(update)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.blue
        polyline.map = mapView // Your map view
    }
    
    /*
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }*/

}

extension GoogleMapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        currentLocation = location
        /*
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }*/
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("hello")
        //getPolylineRoute(from: CLLocationCoordinate2D(latitude: 33.649545, longitude: -117.844663), to: defaultLocation)
        self.performSegue(withIdentifier: "detailSegue", sender: marker.position)
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
