//
//  DBManager.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 30.01.2022.
//

import Foundation
import RealmSwift

class DBManager {
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
    fileprivate var app = App(id: "gotripios-pxcep")
    fileprivate var appUser: User?
    fileprivate var userRealm: Realm?

    func addTripToUser(trip: TripInfoModel, userID: String) {
        try! mainRealm.write {
            mainRealm.add(trip)
        }
    }
    func obtainTripsByUser(id: String) -> [TripInfoModel] {
        let models = mainRealm.objects(TripInfoModel.self).where{$0.ownerID == id}
        
        return Array(models)
    }
    
    func clearAll() {
        try! mainRealm.write {
            mainRealm.deleteAll()
        }
    }
    
    func deleteRealmFile() {
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func getPathURL() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    @objc func signUp() {
        let email = "volsoor@gmail.com"
        let password = "hleb123"
        app.emailPasswordAuth.registerUser(email: email, password: password, completion: { [weak self](error) in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Signup failed: \(error!)")
                    return
                }
                print("Signup successful!")
                self!.signIn()
            }
        })
    }
    @objc func signIn() {
        let email = "volsoor@gmail.com"
        let password = "hleb123"
        
        print("Log in as user: \(email)")
        
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
            DispatchQueue.main.async { [self] in
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                    return
                case .success(let user):
                    print("Login succeeded!")
                    appUser = user
                    userRealm = try! Realm(configuration: user.configuration(partitionValue: "123"))
                    
                    /*let info = TripInfoModel()
                    info.price = TripPriceModel(21.12)
                    info.dateAdded = NSDate()
                    info.placeFrom = "placeFrom"
                    info.placeTo = "placeTo"
                    info.ownerID = "61fbebad7682143ae72d9661"
                    info.type = .Car

                    try! realm.write {
                        realm.add(info)
                    }*/
                    
                    let models = userRealm!.objects(TripInfoModel.self).where{$0.ownerID == appUser!.id}
                    let mArr = Array(models)
                
                    for block in mArr {
                        print(block)
                    }
                    print(mArr.count)
                    
                }
            }
        }
    }
    func logOut() {
        appUser = nil
        userRealm = nil
    }
}
