//
//  GetColor.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 27.11.2021.
//

import UIKit

class TripColors {
    static func getColor(num: Int) -> UIColor {
        switch num {
        case 0:
            return UIColor(named: "AirplaneColor")!
        case 1:
            return UIColor(named: "TrainColor")!
        case 2:
            return UIColor(named: "BusColor")!
        case 3:
            return UIColor(named: "CarColor")!
        default:
            return UIColor(named: "AirplaneColor")!
        }
    }
    static func getStrongColor(num: Int) -> UIColor {
        switch num {
        case 0:
            return UIColor(named: "AirplaneColorStrong")!
        case 1:
            return UIColor(named: "TrainColorStrong")!
        case 2:
            return UIColor(named: "BusColorStrong")!
        case 3:
            return UIColor(named: "CarColorStrong")!
        default:
            return UIColor(named: "AirplaneColorStrong")!
        }
    }
}
