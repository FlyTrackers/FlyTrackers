//
//  FlightSingleton.swift
//  FlyTrackers
//
//  Created by Giovanni Propersi on 4/2/22.
//

import Foundation

class Flights {
    // Singleton that can be shared among all ViewControllers
    static let sharedInstance = Flights()
    var array = [Flight]()
}
