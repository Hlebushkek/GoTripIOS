//
//  TripInfoModel.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 30.01.2022.
//

import RealmSwift
import UIKit

class TripInfoModel: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ownerID: String = ""
    @Persisted var placeFrom: String = ""
    @Persisted var placeTo: String = ""
    @Persisted var price: TripPriceModel? = TripPriceModel.free()
    @Persisted var type: TripType = TripType.airplane
    @Persisted var dateAdded: String = ""
    @Persisted var isFavourite: Bool = false
}

extension TripType: PersistableEnum { }
