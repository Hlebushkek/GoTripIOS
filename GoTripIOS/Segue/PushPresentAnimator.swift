//
//  PushPresentAnimator.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 21.11.2021.
//

import UIKit

class PushPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitionMode = TransitionMode.present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionMode {
        case .present:
            guard let toView = transitionContext.view(forKey: .to) else {
                return
            }
            
            let containerView = transitionContext.containerView
            let duration = transitionDuration(using: transitionContext)
            
            toView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            
            containerView.addSubview(toView)
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                toView.transform = CGAffineTransform.identity
                toView.layoutIfNeeded()
            }, completion: { success in
                transitionContext.completeTransition(true)
            })
        default:
            guard let toView = transitionContext.view(forKey: .to),
                  let fromView = transitionContext.view(forKey: .from) else {
                return
            }
            
            let containerView = transitionContext.containerView
            let duration = transitionDuration(using: transitionContext)
            
            containerView.insertSubview(toView, at: 0)
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                fromView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            }, completion: { success in
                transitionContext.completeTransition(true)
            })
        }
    }
}
