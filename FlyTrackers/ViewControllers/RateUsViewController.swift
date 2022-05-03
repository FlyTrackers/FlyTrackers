//
//  RateUsViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 5/2/22.
//

import UIKit

class RateUsViewController: UIViewController {

    @IBOutlet weak var ratingMessageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ratingMessageLabel.text = "Hi, mom! Thank you for the 5-star rating!"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func takeMeBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
