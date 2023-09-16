//
//  DBManagerProtocol.swift
//  GoTripIOS
//
//  Created by Hlib Sobolevskyi on 2023-09-14.
//

import Foundation

@objc
protocol DBManagerObserverProtocol: ObservingProtocol {
    @objc optional func didLoginIn()
    @objc optional func didLogOut()
}

protocol DBManagerProtocol {
    func signUp(email: String, password: String, completion: @escaping ()->Void)
    func signIn(email: String, password: String, completion: @escaping ()->Void)
    
    func logOut()
    
    func isSignIn() -> Bool    
    func getUser() -> UserInfo?
    
    func fetchTrips(with completion: @escaping ([TripInfoModel])->Void)
    func addTrip(_ trip: TripInfoModel)
}
