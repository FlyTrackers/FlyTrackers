//
//  FavoritesViewController.swift
//  FlyTrackers
//
//  Created by Christian Franklin on 5/7/22.
//

import UIKit
import SwiftyJSON
import Parse
import Foundation

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var flightTableView: UITableView!
    let parseAPI = ParseAPICaller()
    var flights = [Flight]()
    var searchError: UIAlertController!
    
    func getParseFavorites() {
        parseAPI.retrieveFavoritedFlightData(user: PFUser.current()!, completion: { result in
            switch result {
            case .success(let getflights):
                print("Retrieved favorites")
                self.flights = getflights
                if self.flights.isEmpty {
                    self.searchError.message = "No Data to Show"
                    self.present(self.searchError, animated: true, completion: nil)
                    self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
                } else {
                    self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
                    self.flightTableView.reloadData()
                }
            case .failure(let error):
                print("Failed to find favorites due to: \(error)")
           }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getParseFavorites()

        // Create new alert for loading of posts error
        searchError = UIAlertController(title: "Alert", message : "", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        searchError.addAction(ok)
        
        flightTableView.delegate = self
        flightTableView.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! FavoriteCell
        
        cell.flight = flights[indexPath.row]
        return cell
    }

}
