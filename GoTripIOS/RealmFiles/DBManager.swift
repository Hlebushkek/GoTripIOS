//
//  DBManager.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 30.01.2022.
//

import Foundation
import RealmSwift

class DBManager {
    fileprivate lazy var mainLocalRealm = try! Realm(configuration: .defaultConfiguration)
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
        try! mainLocalRealm.write {
            mainLocalRealm.add(trip)
        }
    }
    func localObtainTripsByUser(id: String) -> [TripInfoModel] {
        let models = mainLocalRealm.objects(TripInfoModel.self).where{$0.ownerID == id}
        
        return Array(models)
    }
    
    func localClearAll() {
        try! mainLocalRealm.write {
            mainLocalRealm.deleteAll()
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
    func signUp() {
        let email = "volsoor@gmail.com"
        let password = "hleb123"
        app.emailPasswordAuth.registerUser(email: email, password: password, completion: { [weak self](error) in
            guard error == nil else {
                print("Signup failed: \(error!)")
                return
            }
            print("Signup successful!")
            self!.signIn(email: email, password: password, onSuccess: {})
        })
    }
    func signIn(email: String, password: String, onSuccess: @escaping ()->Void) {
        print("Log in as user: \(email)")
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
            switch result {
            case .failure(let error):
                print("Login failed: \(error)")
                return
            case .success(let user):
                print("Login succeeded!")
                self.appUser = user
                
                onSuccess()
            }
        }
    }
    
    func cloudAddTrip(_ trip: TripInfoModel) {
        guard let user = getUser() else { return }
        let conf = user.configuration(partitionValue: "123")
        
        trip.ownerID = user.id
        
        do {
            let userRealm = try Realm(configuration: conf)
            
            try userRealm.write {
                userRealm.add(trip)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func logOut() {
        print("Log out")
        appUser = nil
    }
    func isSignIn() -> Bool {
        return appUser == nil ? false : true
    }
    func getUser() -> User? {
        return appUser
    }
    
    func getTripCount() -> Int {
        guard let user = getUser() else { return 0 }
        
        do {
            let userRealm = try Realm(configuration: user.configuration(partitionValue: "123"))
            let models = userRealm.objects(TripInfoModel.self).where{$0.ownerID == user.id}
            let modelsArr = Array(models)
            
            return modelsArr.count
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        return 0
    }
    func getTripCountByTrip() -> [Int] {
        guard let user = getUser() else { return [0, 0, 0, 0] }
        
        do {
            let userRealm = try Realm(configuration: user.configuration(partitionValue: "123"))
            let models = userRealm.objects(TripInfoModel.self).where{$0.ownerID == user.id}
            let modelsArr = Array(models)
            
            return [modelsArr.filter({$0.type == .Airplane}).count, modelsArr.filter({$0.type == .Train}).count, modelsArr.filter({$0.type == .Bus}).count, modelsArr.filter({$0.type == .Car}).count]
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        return [0, 0, 0, 0]
    }
    
    
    //Date formatter
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
    
    //
    
    func getTripInfos(onSuccess: @escaping ([TripInfoModel])->Void) {
        guard let user = getUser() else {
            print("appUser not found")
            return
        }
        
        DispatchQueue.main.async {
            do {
                let userRealm = try Realm(configuration: user.configuration(partitionValue: "123"))
                let models = userRealm.objects(TripInfoModel.self).where{$0.ownerID == user.id}
                let modelsArr = Array(models).sorted {
                    DBManager.stringToDate($0.dateAdded) > DBManager.stringToDate($1.dateAdded)
                }
                
                onSuccess(modelsArr)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        
    }
}
