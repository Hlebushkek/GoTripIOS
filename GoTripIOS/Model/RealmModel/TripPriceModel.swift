//
//  TripPriceModel.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 27.07.2022.
//

import RealmSwift

class TripPriceModel: Object, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var integerPart = 0
    @Persisted var fractionalPart = 0
    @Persisted var currencyType: CurrencyType = .EUR
    
    init(_ value: Float) {
        super.init()
        self.integerPart = Int(value)
        self.fractionalPart = Int((value - Float(self.integerPart)) * 100)
    }
    
    override var description: String {
        return "\(integerPart).\(fractionalPart)\(currencyType.rawValue)"
    }
}

extension CurrencyType: PersistableEnum {}
