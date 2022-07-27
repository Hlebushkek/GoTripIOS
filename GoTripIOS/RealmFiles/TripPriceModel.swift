//
//  TripPriceModel.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 27.07.2022.
//

import RealmSwift

class TripPriceModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted private var integerPart = 0
    @Persisted private var fractionalPart = 0
    @Persisted var currencyType: CurrencyType = .EUR
    
    override var description: String {
        return "\(integerPart).\(fractionalPart)\(currencyType.rawValue)"
    }
    
    convenience init(_ value: Float) {
        self.init()
        
        self.integerPart = Int(value)
        self.fractionalPart = Int((value - Float(self.integerPart)) * 100)
    }
    
    func getAsFloat() -> Float {
        return Float(integerPart) + Float(fractionalPart) / 100
    }
    
    static func free() -> TripPriceModel {
        return TripPriceModel(0.0)
    }
}
