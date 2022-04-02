//
//  FlightSingleton.swift
//  FlyTrackers
//
//  Created by Elliott Larsen, Charles Xu, Gio Propersi, Kent Chau, Christian Franklin on 3/19/22.
//

import Foundation

class Flights {
    // Singleton that can be shared among all ViewControllers
    static let sharedInstance = Flights()
    var array = [Flight]()
}
