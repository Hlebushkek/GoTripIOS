//
//  DBManager.swift
//  GoTripIOSRealm
//
//  Created by Gleb Sobolevsky on 30.01.2022.
//

import Foundation
import RealmSwift

@objc
class DBManager: Observable, DBManagerProtocol {
    private lazy var mainLocalRealm = try? Realm(configuration: .defaultConfiguration)
    private var app = App(id: "gotripios-pxcep")
    private var appUser: RealmSwift.User?
    
    static var shared: DBManager = {
            let instance = DBManager()
            return instance
    }()
    
    private override init() {
        super.init()
    }
    
    func localClearAll() {
        try? mainLocalRealm?.write {
            mainLocalRealm?.deleteAll()
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping () -> Void) {
        app.emailPasswordAuth.registerUser(email: email, password: password, completion: { [weak self] (error) in
            guard error == nil else {
                print("Signup failed: \(error!)")
                return
            }
            print("Signup successful!")
            self?.signIn(email: email, password: password, completion: {})
        })
    }
    
    func signIn(email: String, password: String, completion: @escaping ()->Void) {
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
                completion()
            }
        }
    }
    
    func logOut() {
        print("Log out")
        appUser = nil
        
        notifyListeners(with: #selector(DBManagerObserverProtocol.didLogOut))
    }
    
    func isSignIn() -> Bool {
        return appUser != nil
    }
    
    func getUser() -> UserInfo? {
        guard let user = appUser else { return nil }
        return UserInfo(name: user.profile.name ?? "[Undefined]", email: user.profile.email ?? "[Undefined]")
    }
    
    func fetchTrips(with completion: @escaping ([TripInfoModel])->Void) {
        guard let user = appUser else {
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
    
    func getTripCountByTrip() -> [Int] {
        guard let user = appUser else { return [0, 0, 0, 0] }
        
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
    
    func addTrip(_ trip: TripInfoModel) {
        cloudAddTrip(trip)
    }
    
    func cloudAddTrip(_ trip: TripInfoModel) {
        guard let user = appUser else { return }
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
    
    func deleteRealmFile() {
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getPathURL() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}
