//
//  FiltersViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/20/22.
//

import UIKit

class FiltersViewController: UIViewController {

    @IBOutlet weak var arriveControl: UISegmentedControl!
    @IBOutlet weak var delayedControl: UISegmentedControl!
    @IBOutlet weak var timeFromField: UITextField!
    @IBOutlet weak var timeToField: UITextField!
    @IBOutlet weak var terminalField: UITextField!
    @IBOutlet weak var gateField: UITextField!
    
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

}
