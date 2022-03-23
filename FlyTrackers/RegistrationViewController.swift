//
//  RegistrationViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/19/22.
//

import UIKit
import Parse

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var registerUsernameField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet weak var registerRepeatPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
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

    @IBAction func registerLoginButton(_ sender: Any) {
    /*
    Creates user profile/login.
    */
        let user = PFUser()
        user.username = registerUsernameField.text
        user.password = registerPasswordField.text
        let repeatPW = registerRepeatPasswordField.text
        
        user.signUpInBackground { (success, error) in
            // if success and password and repeatPW match:  What constitutes success?
            if success {
                //self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("Success")
            }  // if user already exists or password and repeatPW do not match:
            else {
                // Prevent loginSegue and show an error message.
                print("Error: \(error?.localizedDescription)")
            }
        }
        
    }
    
    
}
