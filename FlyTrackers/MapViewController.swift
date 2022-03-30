//
//  MapViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/20/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    struct Flight {
        var name: String
        var latitude: CLLocationDegrees
        var longitude: CLLocationDegrees
    }

    @IBOutlet weak var ETALabel: UILabel!
    @IBOutlet weak var arrivalLocationLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let flights =
    [Flight(name: "JFK", latitude: 40.641766, longitude: -73.780968),
    Flight(name: "LAX", latitude: 33.942791, longitude: -118.410042)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeFlightsOnMap(flights)
    }
    
    func placeFlightsOnMap(_ flight_list: [Flight]) {
        for flight in flight_list{
            let annotations = MKPointAnnotation()
            annotations.title = flight.name
            annotations.coordinate = CLLocationCoordinate2D(latitude: flight.latitude, longitude: flight.longitude)
            mapView.addAnnotation(annotations)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
