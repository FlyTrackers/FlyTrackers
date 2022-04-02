//
//  MapViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/20/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // schema for flight object
    struct Flight {
        var name: String
        var latitude: CLLocationDegrees
        var longitude: CLLocationDegrees
//        var airlineName: String
//        var flightNumber: String
//        var eta: Date
//        var delay: Int
//        var departure: String
//        var arrival: String
    }

    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var departureLocationLabel: UILabel!
    @IBOutlet weak var arrivalLocationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var flightpathPolyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeAnnotationPosition = 0
    
    
    let flights =
    [Flight(name: "JFK", latitude: 40.641766, longitude: -73.780968),
    Flight(name: "LAX", latitude: 33.942791, longitude: -118.410042)]
    
    // TODO: EXTRACT json file content and store in these two variables
    let departure_location = CLLocation(latitude: 40.641766, longitude: -73.780968)
    let arrival_location = CLLocation(latitude: 33.942791, longitude: -118.410042)
    


    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        placeFlightsOnMap(flights)
        drawRouteOnMap(departure: departure_location, arrival: arrival_location)
    }
    
    func placeFlightsOnMap(_ flight_list: [Flight]) {
        for flight in flight_list{
            let annotations = MKPointAnnotation()
            annotations.title = flight.name
            annotations.coordinate = CLLocationCoordinate2D(latitude: flight.latitude, longitude: flight.longitude)
            mapView.addAnnotation(annotations)
            setMKAnnotation(location: annotations.coordinate)

        }
    }
    
    func drawRouteOnMap(departure: CLLocation, arrival: CLLocation) {
        var coordinates = [departure_location.coordinate, arrival_location.coordinate]
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        mapView.addOverlay(geodesicPolyline)
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blue
        
        return renderer
    }
    
    func setMKAnnotation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = "Plane"
        mapView.addAnnotation(annotation)
        self.planeAnnotation = annotation
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let planeIdentifier = "Plane"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier)
                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
        
        annotationView.image = UIImage(named: "airplane")

        return annotationView
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
