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

public enum TripType: Int, PersistableEnum, Codable, CaseIterable {
    case airplane
    case train
    case bus
    case car
    
    func title() -> String {
        switch self {
        case .airplane:
            return "Airplane"
        case .train:
            return "Train"
        case .bus:
            return "Bus"
        case .car:
            return "Car"
        }
    }
    
    func imageName() -> String {
        switch self {
        case .airplane:
            return "airplane"
        case .train:
            return "train.side.front.car"
        case .bus:
            return "bus.fill"
        case .car:
            return "car.fill"
        }
    }
    
    func color() -> UIColor {
        return UIColor(named: title()) ?? .black
    }
    
    func colorStrong() -> UIColor {
        return UIColor(named: title() + "Strong") ?? .black
    }
    
    func image(for appearance: UIUserInterfaceStyle = .unspecified) -> UIImage {
        let img = UIImage(systemName: imageName()) ?? .remove
        if let color = TripType.tintColor(for: appearance) {
            return img.withTintColor(color)
        } else {
            return img
        }
    }
    
    static func tintColor(for appearance: UIUserInterfaceStyle) -> UIColor? {
        switch appearance {
        case .unspecified:
            return nil
        case .light:
            return .black
        case .dark:
            return .white
        @unknown default:
            fatalError("Unsupported appearance")
        }
    }
}
