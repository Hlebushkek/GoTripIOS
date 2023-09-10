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
        
        profileInfoStack.alpha = 0
        loginStackView.alpha = 0
        
        if dbManager.isSignIn() {
            guard let user = dbManager.getUser() else { return }
            
            mailLabel.text = user.profile.email
            tripsCountLabel.text = "You have \(dbManager.getTripCount()) trips"
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
            if self.dbManager.isSignIn() {
                self.profileInfoStack.alpha = 1
            } else {
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
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func SignInUpButton(_ sender: Any) {
        loginField.text = "volsoor@gmail.com"
        passwordField.text = "hleb123"
        
        guard let login = loginField.text,
              let password = passwordField.text else { return }

        dbManager.signIn(email: login, password: password, onSuccess: {
            LocalSavingSystem.userInfo = UserInfo(email: login, password: password)
        })
    }
}
