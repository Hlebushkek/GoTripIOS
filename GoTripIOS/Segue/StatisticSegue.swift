//
//  StatisticSegue.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 21.11.2021.
//

import UIKit

class StatisticSegue: UIStoryboardSegue {
    override func perform() {
        swipe()
    }
    
    func swipe() {
        let toVC = self.destination as! StatisticViewController
        let fromVC = self.source
        
        let containerView = fromVC.view.superview
        
        toVC.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        toVC.view.layer.cornerRadius = toVC.view.frame.size.height / 2
        
        containerView?.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.layer.cornerRadius = 0
        }, completion: {
            success in fromVC.present(toVC, animated: false, completion: nil)
            toVC.presentStatistic()
        })
    }
}
