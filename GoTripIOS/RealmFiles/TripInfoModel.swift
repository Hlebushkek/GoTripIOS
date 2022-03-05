//
//  TripInfoModel.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 30.01.2022.
//

import Foundation
import RealmSwift

/*class UserModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var login: String = ""
    @Persisted var password: String = ""
    @Persisted var name: String = ""
    @Persisted var email: String = ""
}*/

class TripInfoModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ownerID: String = ""
    @Persisted var placeFrom: String = ""
    @Persisted var placeTo: String = ""
    @Persisted var price: TripPriceModel? = TripPriceModel.free()
    @Persisted var type: TripType = TripType.Airplane
    @Persisted var dateAdded: String = ""
}

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
