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
    var registrationError: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create new alert for registration errors
        registrationError = UIAlertController(title: "Alert", message : "", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        registrationError.addAction(ok)
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerLoginButton(_ sender: Any) {
    /*
    Creates user profile/login.
    */
        
        let new_user = PFUser()
        new_user.username = registerUsernameField.text
        new_user.password = registerPasswordField.text
        let repeatPW = registerRepeatPasswordField.text
        
        // If the password and repeat password do not match.
        if new_user.password != repeatPW {
            // Display an error message.
            self.registrationError.message = "Passwords do not match.\nPlease try again."
            self.present(self.registrationError, animated: true, completion: nil)
        } else {
            new_user.signUpInBackground{ (success, error) in
                switch error {
                    // If the user name is already taken, display an error message.
                case .some(_ as NSError):
                        self.registrationError.message = "This username is already taken.\nPlease try again."
                        self.present(self.registrationError, animated: true, completion: nil)

                    case .none:
                        // Waits 2 sencds before performSegue.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                        })
                    }
                }
        }
}

}
