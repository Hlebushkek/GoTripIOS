//
//  ProfileTabBarController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 05.02.2022.
//

import Foundation
import UIKit

class ProfileTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarHidden(false, animated: animated, completion: nil)
    }
}

extension ProfileTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}

extension ProfileTabBarController {
    func setTabBarHidden(_ isHidden: Bool, animated: Bool, completion: (() -> Void)? = nil ) {
        let height = tabBar.frame.size.height
        let duration = (animated ? 0.25 : 0.0)

        if !isHidden {
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: height)
            self.tabBar.isHidden = false
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.transform = isHidden ? CGAffineTransform(translationX: 0, y: height) : .identity
        }) { _ in
            self.tabBar.isHidden = isHidden
            completion?()
        }
    }
}
