//
//  HomeViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/19/22.
//

import UIKit
import SwiftyJSON
import Parse

class HomeViewController: UIViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var airlineField: UITextField!
    @IBOutlet weak var flightNumberField: UITextField!
    @IBOutlet weak var flightDateField: UITextField!
    
    var flights = [Flight]()
    var flightsForDisplay = [Flight]()
    var inputAirline: String = ""
    var inputFlightNumber: String = ""
    var inputFlightDate: String = ""
    var userInput = [String: String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func searchButton(_ sender: Any) {
    // Get API data for 100 flights
        
        inputAirline = airlineField.text ?? ""
        inputFlightNumber = flightNumberField.text ?? ""
        inputFlightDate = flightDateField.text ?? ""
        
        // No inputs, pass error
        if (inputAirline == "" && inputFlightNumber == "" && inputFlightDate == ""){
            self.errorLabel.text = "Please enter at least one search term."
            return
        }
        
        // Clear error
        self.errorLabel.text = ""
        
        // Clear the singleton and local array since using a new search
        Flights.sharedInstance.array.removeAll()
        self.flights.removeAll()
        
        // Call API
        let url = URL(string: "http://api.aviationstack.com/v1/flights?access_key=92c9f0a9411fa073792716e24c75dc00")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
            if let error = error {
                   print(error.localizedDescription)
            } else if let data = data {
                    do {
                        let dataDictionary = try JSON(data: data)
                        for singleFlight in dataDictionary["data"] {
                            let flight = singleFlight.1
                            let flightData = Flight.init(flight: flight)
                            self.flights.append(flightData)
                        }
                        
                        // Filter out the data based on search options
                        self.getOnlyInputRequestedData()
                        
                        // Send to results tab

                        self.tabBarController?.selectedIndex = 1
                        
                    } catch {
                        // Couldn't read in the JSON data correctly
                        self.errorLabel.text = "Error reading JSON"
                        return
                    }
            }
       }
       task.resume()
    }
            
    func getOnlyInputRequestedData() {
        // Filter out the flights based on the user input
        userInput = [
            "Airline": inputAirline,
            "FlightNumb": inputFlightNumber,
            "FlightDate": inputFlightDate
        ]
        
        for flight in self.flights{
            // Find the ones with the matching airline, flight number, and flight date
            
            if doesFlightMatchInput(singleFlight: flight) {
                Flights.sharedInstance.array.append(flight)
            }
        }
    }
    
    func doesFlightMatchInput(singleFlight: Flight) -> Bool {
        // Check if the flight matches the input data
        
        var doesMatch: Bool = true
        
        let airline = userInput["Airline"]
        let flightNumb = userInput["FlightNumb"]
        let inputDate = userInput["FlightDate"]

        if airline != "" && !singleFlight.airline.contains(airline!) {
            // Airline input is not empty, and flight from API does not contain the input string
            doesMatch = false
        }

        if flightNumb != "" && flightNumb != singleFlight.flightNumber {
            // Flight number input is not empty, and flight number from API does not equal the input flight number
            doesMatch = false
        }

        if inputDate != "" && inputDate != singleFlight.flightDate {
            // Flight date input is not empty, and flight date from API does not equal the input date
            doesMatch = false
        }
        
        return doesMatch
    }
    
}


