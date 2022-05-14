//
//  LoginViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen & Christian Franklin on 3/19/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginUsernameField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    var loginError: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Create new alert for registration errors
        loginError = UIAlertController(title: "Alert", message : "", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        loginError.addAction(ok)
    }
        
    @IBAction func loginButton(_ sender: Any) {
    /*
     Login button.  Authentication and retrieval of user info.
     */
        let username = loginUsernameField.text!
        let password = loginPasswordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password)
        { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.loginError.message = "Invalid username/password."
                self.present(self.loginError, animated: true, completion: nil)
                
            }
        }
        
    }
   
    @IBAction func newRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
    @IBAction func loginGuest(_ sender: Any) {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    

    
}
