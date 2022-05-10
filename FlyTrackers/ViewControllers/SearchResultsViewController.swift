//
//  SearchResultsViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen, Charles Xu, Gio Propersi, Kent Chau, Christian Franklin on 3/19/22.
//

import UIKit
import SwiftyJSON


class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var flightTableView: UITableView!
    var flights = [Flight]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightTableView.delegate = self
        flightTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // User had a successful API request, reload table and cells
        self.flights.removeAll()
        self.flights = Flights.sharedInstance.array
        self.flightTableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueMap") {
            print("Loading Map View screen")
            // Find flight from search results
            let cell = sender as! UITableViewCell
            let indexPath = flightTableView.indexPath(for: cell)!
            let flight = flights[indexPath.row]
            
            // Pass flight to Map View
            let mapViewController = segue.destination as! MapViewController
            mapViewController.flight = flight
        }

        
    }

    // MARK: - Table protocol functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell
        
        cell.flight = flights[indexPath.row]
        return cell
    }

}
