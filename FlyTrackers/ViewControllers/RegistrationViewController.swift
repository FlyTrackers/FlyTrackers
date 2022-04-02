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
        
        let new_user = PFUser()
        new_user.username = registerUsernameField.text
        new_user.password = registerPasswordField.text
        let repeatPW = registerRepeatPasswordField.text
        
        // If the password and repeat password do not match.
        if new_user.password != repeatPW {
            print("Passwords do not match")
            // Display an error message.
            self.errorLabel.text = "Passwords do not match.\nPlease try again."
        } else {
            new_user.signUpInBackground{ (success, error) in
                switch error {
                    // If the user name is already taken, display an error message.
                    case .some(let error as NSError):
                        print(error.localizedDescription)
                    self.errorLabel.text = "This username is already taken.\nPlease try again."

                    case .none:
                        print("Success")
                        self.errorLabel.text = "Registration Successful.\nTaking you to the Home screen."
                        // Waits 2 sencds before performSegue.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                        })
                    //self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                }
        }
}

}
