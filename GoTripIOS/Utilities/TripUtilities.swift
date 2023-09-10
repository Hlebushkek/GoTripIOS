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
}
