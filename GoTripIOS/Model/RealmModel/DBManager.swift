//
//  DBManager.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 30.01.2022.
//

import Foundation
import RealmSwift

@objc
protocol DBManagerObserverProtocol: ObservingProtocol {
    @objc optional func didLoginIn()
    @objc optional func didLogOut()
}

@objc
class DBManager: Observable {
    fileprivate lazy var mainLocalRealm = try! Realm(configuration: .defaultConfiguration)
    fileprivate var app = App(id: "gotripios-pxcep")
    fileprivate var appUser: User?
    
    static var shared: DBManager = {
            let instance = DBManager()
            return instance
    }()
    
    private override init() {
        super.init()
    }

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
        app.emailPasswordAuth.registerUser(email: email, password: password, completion: { [weak self] (error) in
            guard error == nil else {
                print("Signup failed: \(error!)")
                return
            }
            print("Signup successful!")
            self?.signIn(email: email, password: password, onSuccess: {})
        })
    }
    func signIn(email: String, password: String, onSuccess: @escaping ()->Void) {
        print("Log in as user: \(email)")
        
        let config = Realm.Configuration(schemaVersion: 3)
        Realm.Configuration.defaultConfiguration = config
        
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("Login failed: \(error)")
                return
            case .success(let user):
                print("Login succeeded!")
                self?.appUser = user
                
                self?.notifyListeners(with: #selector(DBManagerObserverProtocol.didLoginIn))
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
        
        notifyListeners(with: #selector(DBManagerObserverProtocol.didLogOut))
    }
    func isSignIn() -> Bool {
        return appUser == nil ? false : true
    }
    func getUser() -> User? {
        return appUser
    }
    
    func getTrips(with completion: @escaping ([TripInfoModel])->Void) {
        guard let user = getUser() else {
            completion([])
            return
        }
        
        DispatchQueue.main.async {
            do {
                let userRealm = try Realm(configuration: user.configuration(partitionValue: "123"))
                let modelsResult = userRealm.objects(TripInfoModel.self).where{$0.ownerID == user.id}
                let models = Array(modelsResult).sorted {
                    TripUtilities.GetDate(from: $0.dateAdded) > TripUtilities.GetDate(from: $1.dateAdded)
                }
                
                completion(models)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func getTrips(with type: TripType, completion: @escaping ([TripInfoModel])->Void) {
        guard let user = getUser() else {
            completion([])
            return
        }
        
        DispatchQueue.main.async {
            do {
                let userRealm = try Realm(configuration: user.configuration(partitionValue: "123"))
                let modelsResult = userRealm.objects(TripInfoModel.self).where {
                    $0.ownerID == user.id && $0.type == type
                }
                let models = Array(modelsResult).sorted {
                    TripUtilities.GetDate(from: $0.dateAdded) > TripUtilities.GetDate(from: $1.dateAdded)
                }
                
                completion(models)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        
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
            
            return [modelsArr.filter({$0.type == .airplane}).count, modelsArr.filter({$0.type == .train}).count, modelsArr.filter({$0.type == .bus}).count, modelsArr.filter({$0.type == .car}).count]
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        return [0, 0, 0, 0]
    }
}
