//
//  AirlineSelectionTableViewController.swift
//  FlyTrackers
//
//  Created by Giovanni Propersi on 5/14/22.
//

import UIKit
import SwiftyJSON

class AirlineSelectionTableViewController: UITableViewController {

    @IBOutlet var airlineSelectionTable: UITableView!
    
    var namesOfAirlines = [String]()
    var chosenAirline: String = ""
    
    var airlineSelectionPopup: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        airlineSelectionTable.delegate = self
        airlineSelectionTable.dataSource = self
        
        // Create new alert for indicating successful change
        airlineSelectionPopup = UIAlertController(title: "Status", message : "", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        airlineSelectionPopup.addAction(ok)

        self.clearsSelectionOnViewWillAppear = true
        
        getAirlines()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesOfAirlines.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirlineCell", for: indexPath) as! AirlineCell

        cell.airlineName.text = namesOfAirlines[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Useful - https://medium.com/@ldeme/unwind-segues-in-swift-5-e392134c65fd
        print("Airline chosen is \(namesOfAirlines[indexPath.row])")
        chosenAirline = namesOfAirlines[indexPath.row]
        performSegue(withIdentifier: "unwindToFlightSearch", sender: self)
    }

    // MARK: - Get airlines from JSON
    
        func getAirlines() {
            guard let path = Bundle.main.path(forResource: "sorted_airlines", ofType: "json")
            else {
                self.airlineSelectionPopup.message = "Error: Could not find airlines database"
                self.present(self.airlineSelectionPopup, animated: true, completion: nil)
                return
            }
            let url = URL(fileURLWithPath: path)
    
            do {
                let jsonData = try Data(contentsOf: url)
                let searchableData = JSON(jsonData)
                if searchableData != JSON.null {
                    let named_airlines = searchableData["airlines"]
                    
                    for airline in named_airlines {
                        self.namesOfAirlines.append(airline.1["airline_name"].rawValue as! String)
                    }
                    
                    self.airlineSelectionTable.reloadData()
    
                } else {
                    self.airlineSelectionPopup.message = "Error: Could not find airlines database"
                    self.present(self.airlineSelectionPopup, animated: true, completion: nil)
                    return
                }
            }
            catch {
                self.airlineSelectionPopup.message = "Error: Could not find airlines database"
                self.present(self.airlineSelectionPopup, animated: true, completion: nil)
                return
            }
        }
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "unwindToFlightSearch") {
             let airlineSearchViewController = segue.destination as! HomeViewController
             airlineSearchViewController.airlineField.text = chosenAirline
         }
     }
    
}
