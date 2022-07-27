//
//  TripUtilities.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 27.07.2022.
//

import Foundation

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
    
    private static let tripTypesImages = ["airplane", "train.side.front.car", "bus.fill", "car.fill"]
    private static let tripTypesName = ["Airplane", "Train", "Bus", "Car"]
    
    static func getImage(for type: TripType) -> String {
        return tripTypesImages[type.rawValue]
    }
    static func getName(for type: TripType) -> String {
        return tripTypesName[type.rawValue]
    }
}
