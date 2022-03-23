//
//  Parse_API.swift
//  FlyTrackers
//
//  Created by Giovanni Propersi on 3/22/22.
//

import Foundation
import Parse

class ParseAPICaller {
    
    // MARK:  - Register New User
    
    func registerNewUser(username: String, password: String, completion: @escaping (Result<Bool, NSError>) -> ()) {
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password

        newUser.signUpInBackground { (succeeded, error) in
            if let error = error {
                completion(.failure(error as NSError))
            } else {
                completion(.success(succeeded))
            }
        }
    }
    
    /// Example parse call for registering new user
    ///     let parseAPI = ParseAPICaller()
    ///     parseAPI.registerNewUser(username: "Bobo", password: "Bob", completion: { result in
    ///         switch result {
    ///             case .success(let registered):
    ///                 print("Registered: \(registered)")
    ///             case .failure(let error):
    ///                 // Handle Error
    ///                 print(error.localizedDescription)
    ///        }
    ///    })
    
    // MARK: - Login New User
    
    func loginUser(username: String, password: String, completion: @escaping (Result<PFUser?, NSError>) -> ()) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                completion(.failure(error as NSError))
            } else {
                completion(.success(user))
            }
        }
    }
    
    /// Example parse call for logging in user
    ///     let parseAPI = ParseAPICaller()
    ///     parseAPI.loginUser(username: "Bob", password: "Bob", completion: { result in
    ///         switch result {
    ///             case .success(let loggedIn):
    ///                 print("Logged in: \(String(describing: loggedIn!.username!))")
    ///                 print("Current user is:")
    ///                 print(PFUser.current()!.username!)
    ///             case .failure(let error):
    ///                 // Handle error
    ///                 print(error.localizedDescription)
    ///         }
    ///     })

    
}
