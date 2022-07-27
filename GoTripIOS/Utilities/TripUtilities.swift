//
//  TripUtilities.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 27.07.2022.
//

import UIKit

class TripUtilities {
    static func GetDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: string) ?? Date.distantPast
    }
    
    static func GetString(from date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date ?? Date.distantPast)
    }
    
    private static let tripTypeImages = ["airplane", "train.side.front.car", "bus.fill", "car.fill"]
    private static let tripTypeNames = ["Airplane", "Train", "Bus", "Car"]
    
    static func getImage(for type: TripType) -> UIImage {
        return UIImage(systemName: tripTypeImages[type.rawValue]) ?? UIImage.add
    }
    static func getName(for type: TripType) -> String {
        return tripTypeNames[type.rawValue]
    }
    
    private static let tripTypeColorNames = ["AirplaneColor", "TrainColor", "BusColor", "CarColor"]
    static func getColor(for type: TripType) -> UIColor {
        return UIColor(named: tripTypeColorNames[type.rawValue]) ?? UIColor.black
    }
    static func getStrongColor(for type: TripType) -> UIColor {
        return UIColor(named: tripTypeColorNames[type.rawValue] + "Strong") ?? UIColor.black
    }
    
}
