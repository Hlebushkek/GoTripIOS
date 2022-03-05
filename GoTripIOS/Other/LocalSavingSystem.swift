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
    
    static func saveUserInfo(info: UserInfo) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(info)
            UserDefaults.standard.set(data, forKey: defaultsSavingKeys.userInfoKey.rawValue)
        } catch {
            print("Unable to Encode TripInfo (\(error))")
        }
    }
    static func getUserInfo() -> UserInfo? {
        if let data = UserDefaults.standard.data(forKey: defaultsSavingKeys.userInfoKey.rawValue) {
            do {
                let decoder = JSONDecoder()
                let info = try decoder.decode(UserInfo.self, from: data)
                return info
            } catch {
                print("Unable to Decode UserInfo (\(error))")
            }
        }
        return nil
    }
}

public enum defaultsSavingKeys: String {
    case tripInfoKey = "tripinfokey"
    case userInfoKey = "userinfokey"
}

public struct UserInfo: Codable {
    var email: String = ""
    var password: String = ""
}
