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
    @IBOutlet weak var loginErrorLabel: UILabel!
    
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
                //print("Error: \(error?.localizedDescription)")
                self.loginErrorLabel.text = "Invalid username/password."
                
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
