//
//  DBManagerVapore.swift
//  GoTripIOSVapor
//
//  Created by Hlib Sobolevskyi on 2023-09-16.
//

import Foundation

class DBManager: Observable, DBManagerProtocol {
    
    private let tripsRequest = ResourceRequest<TripInfoModel>(resourcePath: "trip")
    
    static var shared: DBManager = {
            let instance = DBManager()
            return instance
    }()
    
    private override init() {
        super.init()
    }
    
    func signUp(email: String, password: String, completion: @escaping () -> Void) {
        
    }
    
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        
    }
    
    func logOut() {
        
    }
    
    func isSignIn() -> Bool {
        return false
    }
    
    func getUser() -> UserInfo? {
        return nil
    }
    
    func fetchTrips(with completion: @escaping ([TripInfoModel]) -> Void) {
        tripsRequest.getAll { [weak self] tripsResult in
            switch tripsResult {
            case .failure:
                print("There was an error getting the trips")
            case .success(let trips):
                print("Success. Trips.count = \(trips.count)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    completion(trips)
                }
            }
        }
    }
    
    func addTrip(_ trip: TripInfoModel) {
        
    }
}
