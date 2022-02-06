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
        let toVC = self.destination as! UITabBarController
        let fromVC = self.source
        toVC.modalPresentationStyle = .fullScreen

        let containerView = fromVC.view.superview
        let firstTabVC = toVC.viewControllers![0]
        
        firstTabVC.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        firstTabVC.view.layer.cornerRadius = toVC.view.frame.size.height / 2
        
        containerView?.addSubview(firstTabVC.view)

        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            firstTabVC.view.transform = CGAffineTransform.identity
            firstTabVC.view.layer.cornerRadius = 0
        }, completion: {
            success in fromVC.present(toVC, animated: false, completion: nil)
        })
    }
}
