//
//  TripInfoModel.swift
//  GoTripIOSVapor
//
//  Created by Hlib Sobolevskyi on 2023-09-16.
//

import Foundation

class TripInfoModel: Codable {
    var id: UUID = UUID()
    var ownerID: String = ""
    var placeFrom: String = ""
    var placeTo: String = ""
    var price: TripPriceModel? = TripPriceModel.free()
    var type: TripType = TripType.airplane
    var dateAdded: String = ""
    var isFavourite: Bool = false
}
