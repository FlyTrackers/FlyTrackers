//
//  SearchResultsViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/20/22.
//

import UIKit
import SwiftyJSON


class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var flightTableView: UITableView!
    var flights = [Flight]()
    var searchError: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create new alert for loading of posts error
        searchError = UIAlertController(title: "Alert", message : "", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        searchError.addAction(ok)
        
        flightTableView.delegate = self
        flightTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Flights.sharedInstance.array.isEmpty {
            // User tried to access tab without running the API first, disable Filter segue
            self.searchError.message = "No Data to Show"
            self.present(self.searchError, animated: true, completion: nil)
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
        } else {
            
            // User had a successful API request, enable Filter segue as well
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
            self.flights.removeAll()
            self.flights = Flights.sharedInstance.array
            self.flightTableView.reloadData()
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
