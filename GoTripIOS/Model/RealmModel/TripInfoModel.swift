//
//  TripInfoModel.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 30.01.2022.
//

import RealmSwift

/*class UserModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var login: String = ""
    @Persisted var password: String = ""
    @Persisted var name: String = ""
    @Persisted var email: String = ""
}*/

class TripInfoModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ownerID: String = ""
    @Persisted var placeFrom: String = ""
    @Persisted var placeTo: String = ""
    @Persisted var price: TripPriceModel? = TripPriceModel.free()
    @Persisted var type: TripType = TripType.Airplane
    @Persisted var dateAdded: String = ""
    @Persisted var isFavourite: Bool = false
}

extension TripInfoModel {
    static func empty() -> TripInfoModel {
        let info = TripInfoModel()
        info.ownerID = "[Undefined]"
        info.placeFrom = "[Undefined]"
        info.placeTo = "[Undefined]"
        info.price = .free()
        info.type = .Airplane
        info.dateAdded = TripUtilities.GetString(from: Date.distantPast)
        info.isFavourite = false
        
        return info
    }
}
