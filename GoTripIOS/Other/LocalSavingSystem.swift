//
//  LocalSavingSystem.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 29.10.2021.
//

import Foundation

public class LocalSavingSystem {
    static func SaveTripInfo(path: String, info: [TripInfo]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(info)
            UserDefaults.standard.set(data, forKey: path)
        } catch {
            print("Unable to Encode TripInfo (\(error))")
        }
    }
    static func LoadTripInfp(path: String) -> [TripInfo]? {
        if let data = UserDefaults.standard.data(forKey: path) {
            do {
                let decoder = JSONDecoder()
                let info = try decoder.decode([TripInfo].self, from: data)
                return info
            } catch {
                print("Unable to Decode TripInfp (\(error))")
            }
        }
        return nil
    }
}

public struct defaultsSavingKeys {
    static let tripInfoKey = "tripinfokey"
}
