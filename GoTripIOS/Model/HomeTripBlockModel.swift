//
//  HomeTripBlockModel.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 29.10.2021.
//

import Foundation
import RealmSwift

public struct TripInfo: Codable {
    public let placeFrom: String
    public let placeTo: String
    public let price: TripPrice
    public let type: TripType
    
    public static func empty() -> TripInfo {
        return TripInfo(placeFrom: "Undefined", placeTo: "Undefined", price: TripPrice(), type: .Airplane)
    }
}

extension TripInfo {
    public static func example() -> TripInfo{
        return TripInfo(placeFrom: "place1", placeTo: "place2", price: TripPrice(), type: .Bus)
    }
}

public enum TripType: Int, PersistableEnum, Codable {
    case Airplane
    case Train
    case Bus
    case Car
}
