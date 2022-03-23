//
//  LoginViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/19/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginUsernameField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parseAPI = ParseAPICaller()
        
        parseAPI.registerNewUser(username: "Bob", password: "Bob")
        
        
        //ParseAPICaller.registerNewUser(username: "Bob", password: "Bob")
        
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
    }
    
}
