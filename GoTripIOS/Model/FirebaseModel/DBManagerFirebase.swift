//
//  DBManagerFirebase.swift
//  GoTripIOSFirebase
//
//  Created by Hlib Sobolevskyi on 2023-09-15.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class DBManager: Observable, DBManagerProtocol {
    private var db = Firestore.firestore()
    private var appUser: FirebaseAuth.User?
    
    static var shared: DBManager = {
            let instance = DBManager()
            return instance
    }()
    
    private override init() {
        super.init()
        FirebaseApp.configure()
    }
    
    func signUp(email: String, password: String, completion: @escaping () -> Void) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self, error == nil else { return }
            
            print("Signed up. Email: \(result?.user.email ?? "Undefined")")
            appUser = result?.user
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self, error == nil else { return }
            
            print("Signed in. Email: \(result?.user.email ?? "Undefined")")
            appUser = result?.user
        }
    }
    
    func logOut() {
        let firebaseAuth = FirebaseAuth.Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    func isSignIn() -> Bool {
        return appUser == nil
    }
    
    func getUser() -> UserInfo? {
        guard let user = appUser else { return nil }
        return UserInfo(name: user.displayName ?? "[Undefined]", email: user.email ?? "[Undefined]")
    }
    
    func fetchTrips(with completion: @escaping ([TripInfoModel]) -> Void) {
        db.collection("TripInfoModel").getDocuments { querySnapshot, err in
            print(querySnapshot?.documents.count ?? "0")
        }
    }
    
    func addTrip(_ trip: TripInfoModel) {
        
    }
}
