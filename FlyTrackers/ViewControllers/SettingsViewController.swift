//
//  SettingsViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/19/22.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var darkModeControl: UISegmentedControl!
    @IBOutlet weak var changeUsernameField: UITextField!
    @IBOutlet weak var changePasswordField: UITextField!
    @IBOutlet weak var saveChanges: UIButton!
    
    var settingsPopup: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create new alert for indicating successful change
        settingsPopup = UIAlertController(title: "Status", message : "", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in return})
        
        //Add OK button to a dialog message
        settingsPopup.addAction(ok)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        let newUsername = changeUsernameField.text
        let newPassword = changePasswordField.text
        
        guard newUsername != "" || newPassword != "" else {
            return
        }
        
        if newUsername != "" && newPassword == "" {
            changeUsername(newUsername: newUsername!)
            
        } else if newUsername == "" && newPassword != "" {
            changePassword(newPassword: newPassword!)
            
        } else {
            let parseAPI = ParseAPICaller()
            parseAPI.changeUsername(userToChange: PFUser.current()!, newUsername: newUsername!, completion: { result in
                switch result {
                case .success(_):
                    let currentUser = PFUser.current()!
                    currentUser.password = newPassword
                    currentUser.saveInBackground()
                    self.settingsPopup.message = "Successful username and password change."
                    self.present(self.settingsPopup, animated: true, completion: nil)
                case .failure(let error):
                    self.settingsPopup.message = "Error: \(error.localizedDescription)\nCode: \(error.code)"
                    self.present(self.settingsPopup, animated: true, completion: nil)
                }
            })
        }
      
        
        
    }
    
    func changeUsername(newUsername: String) {
        let parseAPI = ParseAPICaller()
        parseAPI.changeUsername(userToChange: PFUser.current()!, newUsername: newUsername, completion: { result in
            switch result {
            case .success(_):
                self.settingsPopup.message = "Successful username change."
                self.present(self.settingsPopup, animated: true, completion: nil)
            case .failure(let error):
                self.settingsPopup.message = "Error: \(error.localizedDescription)\nCode: \(error.code)"
                self.present(self.settingsPopup, animated: true, completion: nil)
            }
        })
    }
    
    func changePassword(newPassword: String) {
        let currentUser = PFUser.current()!
        currentUser.password = newPassword
        currentUser.saveInBackground()
        self.settingsPopup.message = "Successful password change."
        self.present(self.settingsPopup, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func rateUsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "rateUs", sender: self)
        
    }
    
    @IBAction func darkModeButton(_ sender: Any) {
        
        let window = UIApplication.shared.keyWindow
        
        if darkModeControl.selectedSegmentIndex == 0 {
            window?.overrideUserInterfaceStyle = .light
        }
        else if darkModeControl.selectedSegmentIndex == 1{
            window?.overrideUserInterfaceStyle = .dark
        }
        else {
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
}
