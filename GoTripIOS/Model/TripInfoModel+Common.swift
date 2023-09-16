//
//  TripInfoModel+Common.swift
//  GoTripIOS
//
//  Created by Hlib Sobolevskyi on 2023-09-15.
//

import Foundation

extension TripInfoModel {
    static func empty() -> TripInfoModel {
        let info = TripInfoModel()
        info.ownerID = "[Undefined]"
        info.placeFrom = "[Undefined]"
        info.placeTo = "[Undefined]"
        info.price = .free()
        info.type = .airplane
        info.dateAdded = TripUtilities.GetString(from: Date.distantPast)
        info.isFavourite = false
        
        return info
    }
}
