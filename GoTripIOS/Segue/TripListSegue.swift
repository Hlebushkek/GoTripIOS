//
//  TripListSegue.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 21.11.2021.
//

import UIKit

class TripListSegue: UIStoryboardSegue {
    override func perform() {
        swipe()
    }
    
    func swipe() {
        guard let toVC = self.destination as? TripListViewController else { return }
        
        let fromVC = self.source
        fromVC.navigationController?.navigationBar.alpha = 0
        
        let containerView = fromVC.view.superview
        
        toVC.view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        toVC.view.layer.cornerRadius = toVC.view.frame.size.width / 2
        containerView?.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.75, delay: 0, options: [.curveEaseInOut], animations: {
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.layer.cornerRadius = 0
        }, completion: { success in
            fromVC.present(toVC, animated: false, completion: nil)
        })
    }
}
