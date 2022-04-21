//
//  Parse_API.swift
//  FlyTrackers
//
//  Created by Giovanni Propersi on 3/22/22.
//

import Foundation
import Parse

class ParseAPICaller {
    
    let invalidFieldInfo: [String : Any] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Invalid Settings Field", value: "Invalid setting column header given. Please use valid, case-sensitive setting column headers.", comment: "") ,
            ]
    
    let usernameExists: [String : Any] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Username Already Exists", value: "Username already exists. Please choose another.", comment: "") ,
            ]
    
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
    ///                 ---HANDLE SUCCESS HERE---
    ///             case .failure(let error):
    ///                 ---HANDLE FAILURE HERE---
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
    ///                 ---HANDLE SUCCESS HERE---
    ///             case .failure(let error):
    ///                 ---HANDLE FAILURE HERE---
    ///         }
    ///     })
    ///
    
    // MARK: - Set a User's DefaultSettings
    
    func setDefaultSettings(newUser: PFUser, completion: @escaping (Result<Bool, NSError>) -> ()) {
        let defaultSettings = PFObject(className: "UserSettings")
        defaultSettings["darkOrLight"] = false
        defaultSettings["units"] = "imperial"
        defaultSettings["language"] = "EN"
        defaultSettings["forUser"] = newUser
        
        defaultSettings.saveInBackground { (success, error) in
            if let error = error {
                completion(.failure(error as NSError))
            } else {
                completion(.success(success))
            }
        }
    }
    
    /// Example parse call for settings a user's default settings
    ///     let parseAPI = ParseAPICaller()
    ///     parseAPI.setDefaultSettins(user: PFUser.current(), completion: { result in
    ///         switch result {
    ///             case .success(let dataSaved):
    ///                 ---HANDLE SUCCESS HERE---
    ///             case .failure(let error):
    ///                 ---HANDLE FAILURE HERE---
    ///         }
    ///     })
    ///
    
    // MARK: - Change a User's Username
    
    /**
        Changes the user's username.
     
        - Parameter userToChange: The current user - this user's settings are being changed
        - Parameter newUsername: A string containing the new username to change to
     
        - Raises errors, either if username already taken, or if Parse returns an error
     */
    func changeUsername(userToChange: PFUser, newUsername: String, completion: @escaping (Result<Bool, NSError>) -> ()) {
        
        let userSettingsQuery = PFUser.query()!
        userSettingsQuery.whereKey("username", equalTo: newUsername)
        userSettingsQuery.getFirstObjectInBackground() {(userWithUsername, error)  in
            
            if let error = error {
                let errorCode = (error as NSError).code
                
                switch errorCode {
                case 101:
                    // 101 Code indicates a user object has not been found with that username
                    userToChange.username = newUsername
                    userToChange.saveInBackground()
                    completion(.success(true))
                
                default:
                    completion(.failure(error as NSError))
                }
            } else {
                // Indicates a user object already has that username
                let error = NSError(domain: "usernameExists", code: 137, userInfo: self.usernameExists)
                completion(.failure(error as NSError))
            }
        }
    }
    
    /// Example parse call for settings a user's default settings
    ///     let parseAPI = ParseAPICaller()
    ///     let newUsername = changeUsernameField.text
    ///
    ///     parseAPI.changeUsername(user: PFUser.current()!, newUsername: newUsername completion: { result in
    ///         switch result {
    ///             case .success(let success):
    ///                 ---HANDLE SUCCESS HERE---
    ///             case .failure(let error):
    ///                 ---HANDLE FAILURE HERE---
    ///         }
    ///     })

    // MARK: - Change a User's DefaultSettings
    
    /**
        Changes the user's settings depending on which setting is changed. Can change one or all available settings. New settings are provided to this function via the dictionary changedSettings.
            Setting column headers are limited to:
                    "darkOrLight" (boolean) - false for dark, true for light mode
                    "units" (string) - Defines the type of units the user sees
                    "language" (string) - Generally a two character strings that defines the language the user sees

     
        - Parameter userToChange: The current user - this user's settings are being changed
        - Parameter changedSettings: A dictionary containing the appropriate setting column headers
     
        - Raises errors, either if incorrect column headers are provided, or if Parse returns an error
     */
    func changeSettings(userToChange: PFUser, changedSettings: [String: Any], completion: @escaping (Result<Bool, NSError>) -> ()) {
        
        let onlySettingColumnHeadersAllowed = ["darkOrLight", "units", "language"]
        
        for (item, _) in changedSettings {
            guard onlySettingColumnHeadersAllowed.contains(item) else {
                let error = NSError(domain: "InvalidFieldName", code: 105, userInfo: invalidFieldInfo)
                completion(.failure(error as NSError))
                return
            }
        }
        
        let userSettingsQuery = PFQuery(className: "UserSettings")
        userSettingsQuery.whereKey("forUser", equalTo: PFUser.current()!)
        userSettingsQuery.getFirstObjectInBackground() {(userSettings, error)  in
            
            if let error = error {
                completion(.failure(error as NSError))
            } else {
                for (item, value) in changedSettings {
                    userSettings![item] = value
                }
                userSettings!.saveInBackground()
                completion(.success(true))
            }
        }
    }
    
    /// Example parse call for settings a user's default settings
    ///     let parseAPI = ParseAPICaller()
    ///     let newSettings: [String: Any] = [
    ///             "darkOrLight": true,
    ///             "units": "metric",
    ///             "language": "ES"
    ///             ]
    ///
    ///     parseAPI.changeSettings(user: PFUser.current()!, changedSettings: newSettings completion: { result in
    ///         switch result {
    ///             case .success(let dataSaved):
    ///                 ---HANDLE SUCCESS HERE---
    ///             case .failure(let error):
    ///                 ---HANDLE FAILURE HERE---
    ///         }
    ///     })

    // MARK: - Add Flight Data
    
    // Note: flightData set to Any until we figure out a proper type to send it in as
    func saveFlightData(user: PFUser, flightData: Any, completion: @escaping (Result<Bool, NSError>) -> ()) {
        let newFlightDataToSave = PFObject(className: "FlightTrack")
        newFlightDataToSave["addedBy"] = user
        newFlightDataToSave["trackingData"] = [flightData]
        
        newFlightDataToSave.saveInBackground { (success, error) in
            if let error = error {
                completion(.failure(error as NSError))
            } else {
                completion(.success(true))
            }
        }
    }
    
    /// Example parse call for saving the data
    ///     let parseAPI = ParseAPICaller()
    ///     parseAPI.saveFlightData(user: PFUser.current(),  flightData: MyJsonData, completion: { result in
    ///         switch result {
    ///             case .success(let dataSaved):
    ///                 ---HANDLE SUCCESS HERE---
    ///             case .failure(let error):
    ///                 ---HANDLE FAILURE HERE---
    ///         }
    ///     })
    
}
