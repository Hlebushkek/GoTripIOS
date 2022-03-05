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
    fileprivate let dispGroup = DispatchGroup()
    fileprivate let dispQueue = DispatchQueue.global(qos: .default)
    fileprivate var app = App(id: "gotripios-pxcep")
    fileprivate var appUser: User?
    
    var trips: [TripInfoModel] = []
    
    static var shared: DBManager = {
            let instance = DBManager()
            return instance
    }()
    
    private init(){}

    //Local
    func localAddTripToUser(trip: TripInfoModel, userID: String) {
        try! mainRealm.write {
            mainRealm.add(trip)
        }
    }
    func localObtainTripsByUser(id: String) -> [TripInfoModel] {
        let models = mainRealm.objects(TripInfoModel.self).where{$0.ownerID == id}
        
        return Array(models)
    }
    
    func localClearAll() {
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
    
    //Cloud
    @objc func signUp() {
        let email = "volsoor@gmail.com"
        let password = "hleb123"
        app.emailPasswordAuth.registerUser(email: email, password: password, completion: { [weak self](error) in
            self!.dispQueue.async {
                guard error == nil else {
                    print("Signup failed: \(error!)")
                    return
                }
                print("Signup successful!")
                self!.signIn(email: email, password: password)
            }
        })
    }
    @objc func signIn(email: String, password: String) {
        print("Log in as user: \(email)")
        dispGroup.enter()
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
            self.dispQueue.async { [self] in
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                    return
                case .success(let user):
                    print("Login succeeded!")
                    appUser = user

                    dispGroup.leave()
                }
            }
        }
    }
    
    func cloudAddTrip(_ trip: TripInfoModel) {
        dispGroup.wait()
        guard let user = appUser else { return }
        let conf = user.configuration(partitionValue: "123")
        let userRealm = try! Realm(configuration: conf)
        
        try! userRealm.write {
            userRealm.add(trip)
        }
    }
    
    func logOut() {
        appUser = nil
    }
    
    func isSignIn() -> Bool {
        if let _ = appUser { return true }
        else { return false }
    }

    func getUser() -> User? {
        dispGroup.wait()
        return appUser
    }
    
    func getTripCount() -> Int {
        guard let user = appUser else { return 0 }
        
        let userRealm = try! Realm(configuration: user.configuration(partitionValue: "123"))
        let models = userRealm.objects(TripInfoModel.self).where{$0.ownerID == user.id}
        let modelsArr = Array(models)
        
        return modelsArr.count
    }
    func getTripCountByTrip() -> [Int] {
        guard let user = appUser else { return [0, 0, 0, 0] }
        
        let userRealm = try! Realm(configuration: user.configuration(partitionValue: "123"))
        let models = userRealm.objects(TripInfoModel.self).where{$0.ownerID == user.id}
        let modelsArr = Array(models)
        
        return [modelsArr.filter({$0.type == .Airplane}).count, modelsArr.filter({$0.type == .Train}).count, modelsArr.filter({$0.type == .Bus}).count, modelsArr.filter({$0.type == .Car}).count]
    }
    
    
    //Date fromatter
    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"

        return dateFormatter.string(from: date)
    }
    static func stringToDate(_ stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"

        return dateFormatter.date(from: stringDate) ?? Date()
    }
}
