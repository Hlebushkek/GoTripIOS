//
//  TripPriceModel.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 24.12.2021.
//

import Foundation
import RealmSwift

public class TripPrice: CustomStringConvertible, Codable {
    
    private var integerPart = 0
    private var fractionalPart = 0
    private var currencyType: CurrencyType = .EUR
    
    public var description: String {
        return "\(integerPart).\(fractionalPart)\(currencyType.rawValue)"
    }
    
    init() {
        
    }
    init(_ value : Int) {
        integerPart = value
    }
    init(_ value : Float) {
        integerPart = Int(value)
        fractionalPart = Int((value - Float(integerPart)) * 100)
    }
    
    func getAsFloat() -> Float {
        return Float(integerPart) + Float(fractionalPart) / 100
    }
    
    public static func free() -> TripPrice {
        return TripPrice(0)
    }
}

enum CurrencyType: String, PersistableEnum, Codable {
    case EUR = "€"
    case USD = "$"
    case UAH = "₴"
}
