//
//  HomeViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/19/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var airlineField: UITextField!
    @IBOutlet weak var flightNumberField: UITextField!
    @IBOutlet weak var flightDateField: UITextField!
    
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
        let airline = airlineField.text
        let flightNumber = flightNumberField.text
        let flightDate = flightDateField.text
        
        print(airline)
        print(flightNumber)
        print(flightDate)
    }
    
}
