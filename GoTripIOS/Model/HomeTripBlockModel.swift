//
//  HomeTripBlockModel.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 29.10.2021.
//

import Foundation

public struct TripInfo: Codable {
    public let placeFrom: String
    public let placeTo: String
    public let price: Decimal
    public let type: TripType
}

extension TripInfo {
    public static func example() -> TripInfo{
        return TripInfo(placeFrom: "place1", placeTo: "place2", price: 192.2, type: .Bus)
    }
}

public enum TripType: Int, Codable {
    case Airplane
    case Train
    case Bus
    case Car
}

public enum CurrencyType {
    case UAH
    case USD
    case EUR
    case RUB
}
