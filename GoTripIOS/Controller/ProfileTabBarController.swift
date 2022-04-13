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
        delegate = self
        
        self.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setTabBarHidden(true, animated: false, completion: {
            self.setTabBarHidden(false, animated: true, completion: nil)
        })
        
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
//        if (tabBar.isHidden == isHidden) {
//            completion?()
//        }

        if !isHidden {
            tabBar.isHidden = false
        }
        let height = tabBar.frame.size.height
        let offsetY = view.frame.height - (isHidden ? 0 : height)
        let duration = (animated ? 0.5 : 0.0)

        let frame = CGRect(origin: CGPoint(x: tabBar.frame.minX, y: offsetY), size: tabBar.frame.size)

        UIView.animate(withDuration: duration, animations: {
            self.tabBar.frame = frame
        }) { _ in
            self.tabBar.isHidden = isHidden
            completion?()
        }
    }
}
