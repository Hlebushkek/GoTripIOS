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

    static var userInfo: UserInfo? {
        get {
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
        set (info) {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(info)
                UserDefaults.standard.set(data, forKey: defaultsSavingKeys.userInfoKey.rawValue)
            } catch {
                print("Unable to Encode TripInfo (\(error))")
            }
        }
    }
    
    static var prefferedCurrency: CurrencyType {
        get {
            if let data = UserDefaults.standard.data(forKey: defaultsSavingKeys.userPrefCur.rawValue) {
                do {
                    let decoder = JSONDecoder()
                    let info = try decoder.decode(CurrencyType.self, from: data)
                    return info
                } catch {
                    print("Unable to Decode UserInfo (\(error))")
                }
            }
            return CurrencyType.USD
        }
        set (newValue) {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: defaultsSavingKeys.userPrefCur.rawValue)
            } catch {
                print("Unable to Encode TripInfo (\(error))")
            }
        }
    }
}

public enum defaultsSavingKeys: String {
    case tripInfoKey = "tripinfokey"
    case userInfoKey = "userinfokey"
    case userPrefCur = "prefferedcurrency"
}

public struct UserInfo: Codable {
    var email: String = ""
    var password: String = ""
}
