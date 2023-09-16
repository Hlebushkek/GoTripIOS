//
//  ProfileViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 06.02.2022.
//

import Foundation
import UIKit



class ProfileViewController: UIViewController {
    
    private var dbManager = DBManager.shared
    
    @IBOutlet weak var profileInfoStack: UIStackView!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var tripsCountLabel: UILabel!
    
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = self.title
        updateUI()
    }
    
    func updateUI() {
        if dbManager.isSignIn() {
            guard let user = dbManager.getUser() else { return }
            
            mailLabel.text = user.email
            dbManager.fetchTrips { [weak self] trips in
                self?.tripsCountLabel.text = "You have \(trips.count) trips"
            }
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: { [weak self] in
            guard let self else { return }
            if self.dbManager.isSignIn() {
                self.loginStackView.alpha = 0
                self.profileInfoStack.alpha = 1
            } else {
                self.profileInfoStack.alpha = 0
                self.loginStackView.alpha = 1
            }
        }, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func SignOutButtonAction(_ sender: Any) {
        let userDef = UserDefaults.standard
        userDef.removeObject(forKey: defaultsSavingKeys.userInfoKey.rawValue)
        
        dbManager.logOut()
        updateUI()
    }

    @IBAction func SignInUpButton(_ sender: Any) {
        loginField.text = "test@gmail.com"
        passwordField.text = "123"
        
        guard let email = loginField.text,
              let password = passwordField.text else { return }

        dbManager.signIn(email: email, password: password, completion: {
            LocalSavingSystem.userInfo = UserInfo(name: "testName", email: email)
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        })
    }
    
    @IBAction func signUp(_ sender: Any) {
        loginField.text = "test@gmail.com"
        passwordField.text = "test123"
        
        guard let email = loginField.text,
              let password = passwordField.text else { return }

        dbManager.signUp(email: email, password: password, completion: {
            LocalSavingSystem.userInfo = UserInfo(name: "testName", email: email)
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        })
    }
}
