//
//  StatisticSegue.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 21.11.2021.
//

import UIKit

class ProfileSegue: UIStoryboardSegue {

    override func perform() {
        swipe()
    }

    func swipe() {
        guard let toVC = self.destination as? UITabBarController else { return }
        let fromVC = self.source
        fromVC.navigationController?.navigationBar.alpha = 0
        
        toVC.modalPresentationStyle = .fullScreen

        let containerView = fromVC.view.superview
        guard let profileVC = toVC.viewControllers?[0] else { return }
        
        profileVC.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        profileVC.view.layer.cornerRadius = toVC.view.frame.size.height / 2

        containerView?.addSubview(profileVC.view)

        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            profileVC.view.transform = CGAffineTransform.identity
            profileVC.view.layer.cornerRadius = 0
        }, completion: { success in
            profileVC.view.removeFromSuperview()
            fromVC.present(toVC, animated: false, completion: nil)
        })
    }
}
