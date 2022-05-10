//
//  MapViewController.swift
//  FlyTrackers
//
<<<<<<< HEAD
//  Created by Charles Xu on 3/20/22.
=======
//  Created by Charles Xu 2022
>>>>>>> last_working_map_before_merge
//

import UIKit
import MapKit
import SwiftyJSON

// convert between radians and degrees
extension CGFloat {
        var toRadians: CGFloat { return self * .pi / 180 }
        var toDegrees: CGFloat { return self * 180 / .pi }
    }

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var departureLocationLabel: UILabel!
    @IBOutlet weak var arrivalLocationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    

    var flightpathPolyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeAnnotationPosition = 0
    var flight: Flight!
    var planeDirection: CLLocationDirection = 0
    
    var liveLocation: CLLocationCoordinate2D!
    
    var departureAirportName: String!
    var departureAirportCoor2D: CLLocationCoordinate2D!
    var departureAirportLoc: CLLocation!
    var departureAirportLat: Double!
    var departureAirportLon: Double!
    var departureICAO: String!
    
    var arrivalAirportName: String!
    var arrivalAirportCoor2D: CLLocationCoordinate2D!
    var arrivalAirportLoc: CLLocation!
    var arrivalAirportLat: Double!
    var arrivalAirportLon: Double!
    var arrivalICAO: String!
    
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
        
        print("----- STARTING MAP VIEW FUNCTIONS -----")
        
        super.viewDidLoad()
                
        print("----- HERE IS THE FLIGHT DATA -----\n\n\n")
        print(flight as Any)
        print("--------------------------------------\n\n\n")

        
        parseJSON() // extract coordinate/name data from local airports JSON
        // MUST run parseJSON() before updateLabels() or else airport name labels don't show up
        updateLabels() // display up-to-date data on map screen
        
        paths =
        [Path(name: flight.departureAirport, coordinates: departureAirportCoor2D),
         Path(name: flight.arrivalAirport, coordinates: arrivalAirportCoor2D)]
        
        print("----- HERE ARE THE FLIGHT PATHS: -----\n\n\n")
        print(paths)
        print("--------------------------------------\n\n\n")
        
        
        mapView.delegate = self
        
        var coordinates = [departureAirportLoc.coordinate, arrivalAirportLoc.coordinate]
        flightpathPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        mapView.addOverlay(flightpathPolyline)
        
        
        let annotation = MKPointAnnotation()
        self.planeAnnotation = annotation
        self.updatePlanePosition()
        mapView.addAnnotation(annotation)

        
        // place the pins for start and end locations
        placeFlightsOnMap(paths)
        // drawMaps replaced here

    }
    
    // update labels with specific flight data
    private func updateLabels(){
        
        // check if we can set live data attributes
        if flight.liveData != JSON.null {
            liveLocation = CLLocationCoordinate2D(latitude: flight.liveData?["latitude"].double ?? 0.0, longitude: flight.liveData?["longitude"].double ?? 0.0)
        }
        
        // format and set the date
        let flightDate = flight.arrivalTime
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let date = dateFormatter.date(from: flightDate) ?? Date()
        let dateString = dateFormatter.string(from: date)
        
        // actually update labels
        airlineLabel.text = flight.airline
        flightLabel.text = flight.flightNumberICAO
        statusLabel.text = flight.flightStatus
        ETALabel.text = dateString
        delayLabel.text = String(flight.departureDelay + flight.arrivalDelay) + " min"
        departureLocationLabel.text = departureAirportName + " (" + departureICAO + ")"
        arrivalLocationLabel.text = arrivalAirportName + " (" + arrivalICAO + ")"
    }
    
    // plot both start and end flight pins on map
    func placeFlightsOnMap(_ pathList: [Path]) {
        var annotationList = [MKAnnotation]()

        let departurePath = pathList[0]
        let arrivalPath = pathList[1]
        
        // create the departure annotation
        let dep_annotations = MKPointAnnotation()
        annotationList.append(dep_annotations)
        dep_annotations.title = departurePath.name
        dep_annotations.coordinate = departurePath.coordinates
        dep_annotations.subtitle = "departure_annotation"
        
        mapView.addAnnotation(dep_annotations)

        // create the arrival annotation
        let arr_annotations = MKPointAnnotation()
        annotationList.append(arr_annotations)
        arr_annotations.title = arrivalPath.name
        arr_annotations.coordinate = arrivalPath.coordinates
        arr_annotations.subtitle = "arrival_annotation"
        
        mapView.addAnnotation(arr_annotations)
        
        // setMKAnnotation(location: annotations.coordinate)
        mapView.showAnnotations(annotationList, animated: true)
        
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

    // display annotation pins
    // NOTE: MKMARKERANNOTATIONVIEW displays pins whereas MKAnnotationView does not...
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                
        let planeIdentifier = "Plane"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier)
                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
                
        // To add same image for both: annotationView.image = UIImage(named: "pin.png")
        // Differentiate start and end points
        if annotation.subtitle == "departure_annotation" {
            annotationView.image = UIImage(named: "pin.png")
        } else if annotation.subtitle == "arrival_annotation" {
            annotationView.image = UIImage(named: "pin.png")
        } else {
            annotationView.image = UIImage(named: "airplane.png")
        }
        
        let angle = CGFloat(degreesToRadians(degrees: planeDirection))
        
        if (annotation.subtitle != "departure_annotation" && annotation.subtitle != "arrival_annotation") {
            annotationView.transform = mapView.transform.rotated(by: angle)
        }
        
        return annotationView
        
        }
    
    @objc func updatePlanePosition() {
        let step = 5
        guard planeAnnotationPosition + step < flightpathPolyline.pointCount
            else { return }

        let points = flightpathPolyline.points()
        
        let previousMapPoint = points[planeAnnotationPosition]
        self.planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]
        
        self.planeAnnotation.coordinate = nextMapPoint.coordinate
        
        self.planeDirection = directionBetweenPoints(sourcePoint: previousMapPoint, destinationPoint: nextMapPoint)
        print("\n ----- PLANE ROTATION ANGLE ----- \n")
        print(self.planeDirection as Any)
        
        perform(#selector(updatePlanePosition), with: nil, afterDelay: 0.03)

//        such a frustrating error...
//        perform("updatePlanePosition")
//        perform(Selector(("updatePlanePosition")), with: nil, afterDelay: 0.03)
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        return radiansToDegrees(radians: atan2(y, x)).truncatingRemainder(dividingBy: 360) + 90
    }

    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / Double.pi
    }

    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    // extract airport coordinates and names from local JSON
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
                
                // set ICAO codes
                departureICAO = flight.departureAirportICAO
                arrivalICAO = flight.arrivalAirportICAO
                
                // set airport names bc api stopped providing names
                departureAirportName = data[departureICAO]["name"].string
                arrivalAirportName = data[arrivalICAO]["name"].string
                
                // display N/A if api fails to provide name
                if (departureAirportName == nil){
                    departureAirportName = "N/A"
                }
                if (arrivalAirportName == nil){
                    arrivalAirportName = "N/A"
                }
                
                // set airport coordinates
                departureAirportCoor2D = CLLocationCoordinate2D(latitude: data[departureICAO]["lat"].double ?? 0.0, longitude: data[departureICAO]["lon"].double ?? 0.0)
                arrivalAirportCoor2D = CLLocationCoordinate2D(latitude: data[arrivalICAO]["lat"].double ?? 0.0, longitude: data[arrivalICAO]["lon"].double ?? 0.0)
                
                // do again but for CLLocation
                departureAirportLoc = CLLocation(latitude: data[departureICAO]["lat"].double ?? 0.0, longitude: data[departureICAO]["lon"].double ?? 0.0)
                arrivalAirportLoc = CLLocation(latitude: data[arrivalICAO]["lat"].double ?? 0.0, longitude: data[arrivalICAO]["lon"].double ?? 0.0)
                
                // extracting more for cleaner code in the future
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
    } // end of parse function
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Conditionals for different flight status...
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
    


}




