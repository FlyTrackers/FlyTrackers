//
//  FiltersViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen & Christian Franklin on 3/20/22.
//

import UIKit
import SwiftyJSON

class FiltersViewController: UIViewController {

    @IBOutlet weak var arriveControl: UISegmentedControl!
    @IBOutlet weak var delayedControl: UISwitch!
    @IBOutlet weak var timeFromField: UITextField!
    @IBOutlet weak var timeToField: UITextField!
    @IBOutlet weak var terminalField: UITextField!
    @IBOutlet weak var gateField: UITextField!
    var flights = [Flight]()
    var sortedFlights = [Flight]()
    var filterChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.flights = Flights.sharedInstance.array
        filterChanged = false
    }

    @IBAction func filterDelay(_ sender: Any) {
        if delayedControl.isOn {
            for flight in self.flights {
                if flight.departureDelay != 0 {
                   self.sortedFlights.append(flight)
                } else if flight.arrivalDelay != 0 {
                    self.sortedFlights.append(flight)
                }
            }
         filterChanged = true
        }
    }
    
    
    @IBAction func filterTerminal(_ sender: Any) {
        for flight in self.flights {
            if flight.arrivalTerminal == terminalField.text {
                self.sortedFlights.append(flight)
            } else if flight.departureTerminal == terminalField.text {
                self.sortedFlights.append(flight)
            }
        filterChanged = true
        }
    }
    @IBAction func filterGate(_ sender: Any) {
        for flight in self.flights {
            if flight.arrivalGate == gateField.text {
                self.sortedFlights.append(flight)
            } else if flight.departureGate == gateField.text {
                self.sortedFlights.append(flight)
            }
        filterChanged = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if filterChanged == true {
            Flights.sharedInstance.array = self.sortedFlights
        }
    }

}
