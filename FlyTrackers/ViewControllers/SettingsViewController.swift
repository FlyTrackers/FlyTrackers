//
//  SettingsViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/19/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var darkModeControl: UISegmentedControl!
    @IBOutlet weak var changeUsernameField: UITextField!
    @IBOutlet weak var changePasswordField: UITextField!
    @IBOutlet weak var locationServicesControl: UISegmentedControl!
    @IBOutlet weak var clearListControl: UISegmentedControl!
    @IBOutlet weak var defaultSearchControl: UISegmentedControl!
    
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
