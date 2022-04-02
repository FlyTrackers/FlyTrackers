//
//  HomeViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/19/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var airlineField: UITextField!
    @IBOutlet weak var flightNumberField: UITextField!
    @IBOutlet weak var flightDateField: UITextField!
    var flights = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func searchButton(_ sender: Any) {
    /*
     Search database with the given parameters.
     */
        let inputAirline = airlineField.text
        let inputFlightNumber = flightNumberField.text
        let inputFlightDate = flightDateField.text
        

        let url = URL(string: "http://api.aviationstack.com/v1/flights?access_key=c2d55483a3720f7e0c461ea64c0544c6")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                 self.flights = dataDictionary["data"] as! [[String: Any]]
                 
                 // If the user did not provide any information.
                 if (inputAirline == "" && inputFlightNumber == "" && inputFlightDate == ""){
                     self.errorLabel.text = "Please enter at least one search term."
                 }
                 
                // Traverse JSON and
                 for index in 1...self.flights.endIndex - 1{
                     
                     // If the name of the airline is provided.
                     if inputAirline != "" {
                         self.errorLabel.text = ""
                         let airline = self.flights[index]["airline"] as! [String:Any]
                         let printAirline = airline["name"] as? String
                     
                         if printAirline == inputAirline{
                             let flightNumber = self.flights[index]["flight"] as! [String:Any]
                             let printFlightNumber = flightNumber["number"] as? String

                             if (printAirline != nil && printFlightNumber != nil){
                                 print("Airline: \(printAirline!) / Flight Number: \(printFlightNumber!)")
                             }
                         }
                     }
                    
                     // If the flight number is provided.
                     if inputFlightNumber != ""{
                         self.errorLabel.text = ""
                         let flightnumber = self.flights[index]["flight"] as! [String:Any]
                         let printFlightNumber = flightnumber["number"] as? String
                         
                         if printFlightNumber == inputFlightNumber{
                             let airline = self.flights[index]["airline"] as! [String:Any]
                             let printAirline = airline["name"] as? String
                             
                             if (printAirline != nil && printFlightNumber != nil){
                                 print("Airline: \(printAirline!) / Flight Number: \(printFlightNumber!)")
                             }
                         }
                     }
                     
                     // If the flight date is provided.
                     if inputFlightDate != ""{
                         self.errorLabel.text = ""
                         let flightDate = self.flights[index] as? [String:Any]
                         let printFlightDate = flightDate?["flight_date"] as? String
                         
                         if printFlightDate == inputFlightDate{
                             let airline = self.flights[index]["airline"] as! [String:Any]
                             let printAirline = airline["name"] as? String
                             
                             let flightNumber = self.flights[index]["flight"] as! [String:Any]
                             let printFlightNumber = flightNumber["number"] as? String
                             
                             if (printAirline != nil && printFlightNumber != nil){
                                 print("Airline: \(printAirline!) / Flight Number: \(printFlightNumber!)")
                             }
                             
                         }
                     }
                     
                 }
                 //let airline = self.flights[1]["airline"] as! [String:Any]
                 //let printAirline = airline["name"] as! String
                 //print(printAirline)
                 //---atempt to output flight name
                 //print(self.flights[0]["airline"]["name"])
                 
                 
             }
        }
        task.resume()

        
        /*
        let airline = airlineField.text
        let flightNumber = flightNumberField.text
        let flightDate = flightDateField.text
        
        print(airline)
        print(flightNumber)
        print(flightDate)
         */
    }
    
}
