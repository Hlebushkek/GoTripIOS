//
//  TripPriceModel.swift
//  GoTripIOSFirebase
//
//  Created by Hlib Sobolevskyi on 2023-09-15.
//

import Foundation

class TripPriceModel: Codable, CustomStringConvertible {
    var id: UUID
    var integerPart = 0
    var fractionalPart = 0
    var currencyType: CurrencyType = .EUR
    
    init(_ value: Float) {
        self.id = UUID()
        self.integerPart = Int(value)
        self.fractionalPart = Int((value - Float(self.integerPart)) * 100)
    }
    
    var description: String {
        return "\(integerPart).\(fractionalPart)\(currencyType.rawValue)"
    }
}
