//
//  SearchResultsViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/20/22.
//

import UIKit
import SwiftyJSON


class SearchResultsViewController: UIViewController {
    
    var flights = [Flight]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://api.aviationstack.com/v1/flights?access_key=92eac302688758c89b558139206b9eb2")!

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
                         
                         //* MARK: Reload cells here

                     } catch {
                         // Couldn't read in the JSON data correctly
                         print("Error reading JSON")
                     }
             }
        }
        task.resume()
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
