//
//  DetailedTripViewTransition.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 27.11.2021.
//

import UIKit

enum TransitionMode: Int {
    case present
    case dismiss
    case pop
}

class DetailedTripViewTransition: NSObject {
    var block = UIView()
    
    var tripType = TripType.airplane
    var startPoint: CGPoint = .zero
    var duration: TimeInterval = 0.5
    
    var transitionMode = TransitionMode.present
}

extension DetailedTripViewTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let blockWidth = UIScreen.main.bounds.width - 4 - 16
        
        if transitionMode == .present {
            guard let presentedView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            
            let viewCenter = presentedView.center
            let viewSize = presentedView.frame.size
            
            block.frame = CGRect(x: 0, y: 0, width: blockWidth, height: 64)
            block.center = startPoint
            block.layer.cornerRadius = HomeTripTableViewCell.Constants.layerCornerRadius
            block.backgroundColor = tripType.color()
            
            presentedView.alpha = 0
            
            containerView.addSubview(block)
            containerView.addSubview(presentedView)
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: { [weak self] in
                self?.block.transform = CGAffineTransform(scaleX: viewSize.width / blockWidth, y: viewSize.height / 64)
                self?.block.center = viewCenter
                self?.block.layer.cornerRadius = 0
            }, completion: { succes in
                presentedView.alpha = 1
                transitionContext.completeTransition(succes)
            })
        } else {
            guard let returningView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }
            
            returningView.removeFromSuperview()
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: { [weak self] in
                self?.block.transform = .identity
                self?.block.layer.cornerRadius = HomeTripTableViewCell.Constants.layerCornerRadius
                self?.block.center = self?.startPoint ?? .zero
            }, completion: { [weak self] result in
                self?.block.removeFromSuperview()
                transitionContext.completeTransition(result)
            })
        }
    }
}
