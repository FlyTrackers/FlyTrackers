//
//  Flight.swift
//  FlyTrackers
//
//  Created by Giovanni Propersi on 4/1/22.
//

import Foundation
import SwiftyJSON

struct Flight {
    
    // Properties of Flight object
    var flightNumberICAO: String
    var flightNumber: String
    var airline: String
    var flightStatus: String
    var flightDate: String
    
    var departureAirportICAO: String
    var departureAirport: String
    var departureDelay: Int
    var departureTime: String
    
    var arrivalAirportICAO: String
    var arrivalAirport: String
    var arrivalDelay: Int
    var arrivalTime: String
    
    var liveData: JSON?

    // --- Initializer for Flight ---
    init(flight: JSON) {
        // General Properties
        flightNumberICAO = flight["flight"]["icao"].string ?? ""
        flightNumber = flight["flight"]["number"].string ?? ""
        airline = flight["airline"]["name"].string ?? ""
        flightStatus = flight["flight_status"].string ?? ""
        flightDate = flight["flight_date"].string ?? ""
        
        // Departure Properties
        departureAirportICAO = flight["departure"]["ICAO"].string ?? "N/A"
        departureAirport = flight["departure"]["airport"].string ?? "N/A"
        departureDelay = flight["departure"]["delay"].int ?? 0              // Minutes
        departureTime = flight["departure"]["scheduled"].string ?? "N/A"
        
        // Arrival Properties
        arrivalAirportICAO = flight["arrival"]["icao"].string ?? "N/A"
        arrivalAirport = flight["arrival"]["airport"].string ?? "N/A"
        arrivalDelay = flight["arrival"]["delay"].int ?? 0                  // Minutes
        arrivalTime = flight["arrival"]["scheduled"].string ?? "N/A"
        
        if flight["live"] == JSON.null {
            liveData = JSON.null
        } else {
            liveData = flight["live"]
        }
    }
    
    // Helper function to get time till arrival
    func getTimeToArrival() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormatter.date(from: self.arrivalTime)
        let secondsUntilLanding = Int(date!.timeIntervalSinceNow)
        if secondsUntilLanding > 59 {
            // At least a minute has passed
            var timeInMin = Int(secondsUntilLanding / 60)
            
            if timeInMin > 59 {
                // At least 1 hr has passed
                var timeInHrs = Int(timeInMin / 60)
                
                if timeInHrs > 23 {
                    // At least 1 day has passed
                    let timeInDays = lround(Double(timeInHrs / 24))
                    return "\(timeInDays)d"
                    
                } else {
                    timeInHrs = lround(Double(timeInMin) / 60)
                    return "\(timeInHrs)h"
                }
                
            } else {
                timeInMin = lround(Double(secondsUntilLanding) / 60)
                return "\(timeInMin)m"
            }
            
        }
        return "Landed"
    }
        
}
