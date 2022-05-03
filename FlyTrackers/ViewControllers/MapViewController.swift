//
//  MapViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/20/22.
//

import UIKit
import MapKit
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var departureLocationLabel: UILabel!
    @IBOutlet weak var arrivalLocationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var departureICAO: String!
    var arrivalICAO: String!
    var flightpathPolyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeAnnotationPosition = 0
    var flight: Flight!
    
    var departureAirportCoord: CLLocationCoordinate2D!
    var departureAirportLoc: CLLocation!
    var departureAirportLat: Double!
    var departureAirportLon: Double!
    var arrivalAirportCoord: CLLocationCoordinate2D!
    var arrivalAirportLoc: CLLocation!
    var arrivalAirportLat: Double!
    var arrivalAirportLon: Double!
    
    var departureAirportName: String!
    var arrivalAirportName: String!
    
    var paths = [Path]()
    
    struct Results: Codable {
        let result: Airport // dict with key String and value Airport
    }
    
    struct Airport: Codable {
        var icao: String
        var iata: String
        var name: String
        var city: String
        var state: String
        var country: String
        var elevation: Int
        var lat: Double
        var lon: Double
        var tz: String
    }
    
    // schema for flight path (to be plotted)
    struct Path {
         var name: String!
        var coordinates: CLLocationCoordinate2D!
    }

    // VIEW DID LOAD function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Below is the flight row data")
        print(flight as Any)
        
        updateLabels() // display up-to-date data on map screen
        parseJSON() // extract coordinate data from local airports JSON
        
        paths =
        [Path(name: flight.departureAirport, coordinates: departureAirportCoord),
         Path(name: flight.arrivalAirport, coordinates: arrivalAirportCoord)]
        
        print("HERE ARE THE PATHS:")
        print(paths)
        
        mapView.delegate = self

        placeFlightsOnMap(paths) // place the pins for start and end locations
        
        drawRouteOnMap() // draw the polygeodesic line

    }
    
    // update labels with specific flight data
    private func updateLabels(){
        let flightDate = flight.arrivalTime
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let date = dateFormatter.date(from: flightDate) ?? Date()
        let dateString = dateFormatter.string(from: date)
        
        airlineLabel.text = flight.airline
        flightLabel.text = flight.flightNumber
        statusLabel.text = flight.flightStatus
        ETALabel.text = dateString
        delayLabel.text = String(flight.departureDelay + flight.arrivalDelay) + " min"
        departureLocationLabel.text = flight.departureAirport
        arrivalLocationLabel.text = flight.arrivalAirport
        departureICAO = flight.departureAirportICAO
        arrivalICAO = flight.arrivalAirportICAO
        
        departureAirportName = flight.departureAirport
        arrivalAirportName = flight.arrivalAirport
    }
    
    // plot both start and end flight pins on map
    func placeFlightsOnMap(_ pathList: [Path]) {
        var annotationList = [MKAnnotation]()

        let departurePath = pathList[0]
        let arrivalPath = pathList[1]
        
        let dep_annotations = MKPointAnnotation()
        annotationList.append(dep_annotations)
        dep_annotations.title = departurePath.name // either the departure loc. or arrival loc.
        dep_annotations.coordinate = departurePath.coordinates
        dep_annotations.subtitle = "departure_annotation"
        
        mapView.addAnnotation(dep_annotations)

        let arr_annotations = MKPointAnnotation()
        annotationList.append(arr_annotations)
        arr_annotations.title = arrivalPath.name // either the departure loc. or arrival loc.
        arr_annotations.coordinate = arrivalPath.coordinates
        arr_annotations.subtitle = "arrival_annotation"
        
        mapView.addAnnotation(arr_annotations)
        
        // setMKAnnotation(location: annotations.coordinate)
        mapView.showAnnotations(annotationList, animated: true)
    }


    // display annotation pins
    // NOTE: MKMARKERANNOTATIONVIEW displays pins whereas MKAnnotationView does not...
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView! {
        let planeIdentifier = "Plane"
        
    //  mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: planeIdentifier)
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier)
                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
                
        print("THIS IS THE SUBTITLE FOR THE ANNOTATION")
        print(annotation.subtitle!!)
        
        annotationView.image = UIImage(named: "pin.png")
        
//        if annotation.subtitle == "departure_annotation" {
//            annotationView.image = UIImage(named: "scheduled.png")
//        } else {
//            annotationView.image = UIImage(named: "landed.png")
//        }
//
//        if flight.flightStatus == "scheduled"{
//            annotationView.image = UIImage(named: "active.png")
//        } else if flight.flightStatus == "active" {
//            annotationView.image = UIImage(named: "active.png")
//        } else if flight.flightStatus == "landed" {
//            annotationView.image = UIImage(named: "landed.png")
//        } else if flight.flightStatus == "cancelled" {
//            annotationView.image = UIImage(named: "cancelled.png")
//        } else if flight.flightStatus == "incident" {
//            annotationView.image = UIImage(named: "incident.png")
//        } else if flight.flightStatus == "diverted" {
//            annotationView.image = UIImage(named: "diverted.png")
//        } else {
//            annotationView.image = UIImage(named: "error.png")
//        }
        
//        annotationView.transform = mapView.transform.rotated(by: CGFloat(degreesToRadians(degrees: 0)))
        
        return annotationView
    }
    
    
//     set the plane annotation pin
//        func setMKAnnotation(location: CLLocationCoordinate2D) {
//            let annotation = MKPointAnnotation()
//            annotation.title = "Plane"
//            mapView.addAnnotation(annotation)
//            self.planeAnnotation = annotation
//        }
    
    // display plane pin on map
    //    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    //        let planeIdentifier = "Plane"
    //        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier)
    //                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
    //        annotationView.image = UIImage(named: "AppIcon.png")
    //        return annotationView
    //    }
    

    // draw the geodesicPolyline on the map
    func drawRouteOnMap() {
        var coordinates = [departureAirportLoc.coordinate, arrivalAirportLoc.coordinate]
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
         mapView.addOverlay(geodesicPolyline)
    }
    
    // display poly line
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 5.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.systemBlue
        return renderer
    }
    
    // extract location coordinates of airports from local JSON
    func parseJSON() {
        guard let path = Bundle.main.path(forResource: "airports", ofType: "json")
        else {
            print("JSON file not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            if (try? JSON(jsonData)) != nil {
                let data = JSON(jsonData)
                departureAirportCoord = CLLocationCoordinate2D(latitude: data[departureICAO]["lat"].double ?? 0.0, longitude: data[departureICAO]["lon"].double ?? 0.0)
                arrivalAirportCoord = CLLocationCoordinate2D(latitude: data[arrivalICAO]["lat"].double ?? 0.0, longitude: data[arrivalICAO]["lon"].double ?? 0.0)
                
                departureAirportLoc = CLLocation(latitude: data[departureICAO]["lat"].double ?? 0.0, longitude: data[departureICAO]["lon"].double ?? 0.0)
                arrivalAirportLoc = CLLocation(latitude: data[arrivalICAO]["lat"].double ?? 0.0, longitude: data[arrivalICAO]["lon"].double ?? 0.0)
                
                departureAirportLat = data[departureICAO]["lat"].double
                departureAirportLon = data[departureICAO]["lon"].double
                arrivalAirportLat = data[arrivalICAO]["lat"].double
                arrivalAirportLon = data[arrivalICAO]["lon"].double
            } else {
                return
            }
        }
        catch {
            print("Error \(error)")
        }
        
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / .pi
    }

    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        return radiansToDegrees(radians: (atan2(y, x)).truncatingRemainder(dividingBy: 450))
    }
    
//    trying to get animated live plane location...
//    func updatePlanePosition() {
//        let step = 5
//        guard planeAnnotationPosition + step < flightpathPolyline.pointCount
//            else { return }
//
//        let points = flightpathPolyline.points()
//        self.planeAnnotationPosition += step
//        let nextMapPoint = points[planeAnnotationPosition]
//
//        self.planeAnnotation.coordinate = nextMapPoint.coordinate
//
//        perform("updatePlanePosition", with: nil, afterDelay: 0.03)
//    }

}

