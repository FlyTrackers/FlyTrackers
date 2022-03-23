//
//  Parse_API.swift
//  FlyTrackers
//
//  Created by Giovanni Propersi on 3/22/22.
//

import Foundation
import Parse

class ParseAPICaller {
    
    // Register a New User
    func registerNewUser(username: String, password: String) {
        let new_user = PFUser()
        new_user.username = username
        new_user.password = password
        
        new_user.signUpInBackground{ (success, error) in
            switch error {
                case .some(let error as NSError):
                    print(error.localizedDescription)
                
                case .none:
                    print("Success")
            }
        }
    }
}
