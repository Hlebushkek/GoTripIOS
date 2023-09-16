//
//  TripPriceModel+Common.swift
//  GoTripIOS
//
//  Created by Hlib Sobolevskyi on 2023-09-15.
//

import Foundation

extension TripPriceModel {
    func getAsFloat() -> Float {
        return Float(integerPart) + Float(fractionalPart) / 100
    }
    
    static func free() -> TripPriceModel {
        return TripPriceModel(0.0)
    }
}
