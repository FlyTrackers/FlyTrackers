//
//  AirlineSelectionTableViewController.swift
//  FlyTrackers
//
//  Created by Giovanni Propersi on 5/14/22.
//

import UIKit
import SwiftyJSON
import Alamofire
import CryptoKit

class AirlineSelectionTableViewController: UITableViewController {

    @IBOutlet var airlineSelectionTable: UITableView!
    
    var namesOfAirlines = [String]()
    var filteredNames = [String]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var chosenAirline: String = ""
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
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
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Airlines"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNames.count
        }
        
        return namesOfAirlines.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirlineCell", for: indexPath) as! AirlineCell
        
        let airlineNameForRow: String
        
        if isFiltering {
            airlineNameForRow = filteredNames[indexPath.row]
        } else {
            airlineNameForRow = namesOfAirlines[indexPath.row]
        }
        
        cell.airlineName.text = airlineNameForRow
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Useful for unwinding - https://medium.com/@ldeme/unwind-segues-in-swift-5-e392134c65fd
        
        if isFiltering {
            chosenAirline = filteredNames[indexPath.row]
        } else {
            chosenAirline = namesOfAirlines[indexPath.row]
        }
        
        
        // Wouldn't let me transition from searched airline to flight search without this
        // Needs to finish the navigation controller animation before returning to flight search
        // https://stackoverflow.com/questions/60953103/popviewcontrolleranimated-called-on-uinavigationcontroller-while-an-existing-tr
        let completion = {
            self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "unwindToFlightSearch", sender: self)
        }

        guard let coordinator = transitionCoordinator else {
            completion()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in
            completion()
        }
        
    }
    
    // MARK: - Filter Content
    
    func filterContentForSearchText(_ searchText: String) {
        filteredNames = namesOfAirlines.filter { (airlineName: String) -> Bool in
            return airlineName.lowercased().contains(searchText.lowercased())
        }
        
        airlineSelectionTable.reloadData()
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

// MARK: - Search Bar
extension AirlineSelectionTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
