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
    var tripType = TripType.airplane
    var block = UIView()
    var startPoint = CGPoint.zero
    var duration = 0.5
    
    var transitionMode = TransitionMode.present
}
extension DetailedTripViewTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: .to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                let blockWidth = UIScreen.main.bounds.width - 4 - 16
                
                block = UIView()
                block.frame = CGRect(x: 0, y: 0, width: blockWidth, height: 64)
                block.center = startPoint
                block.layer.cornerRadius = 16
                block.backgroundColor = tripType.color()
                
                containerView.addSubview(block)
                
                presentedView.center = startPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
                    self.block.transform = CGAffineTransform(scaleX: viewSize.width / blockWidth, y: viewSize.height / 64)
                    self.block.center = viewCenter
                    self.block.layer.cornerRadius = 0
                    
                    presentedView.transform = .identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                }, completion: { succes in
                    transitionContext.completeTransition(succes)
                })
            }
        } else {
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                
                UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
                    self.block.transform = .identity
                    self.block.layer.cornerRadius = 16
                    self.block.center = self.startPoint
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startPoint
                    returningView.alpha = 0
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.block, belowSubview: returningView)
                    }
                    
                }, completion: {(succes: Bool) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    
                    self.block.removeFromSuperview()
                    
                    transitionContext.completeTransition(succes)
                })
            }
            
        }
    }
    
    func frameForBlock(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
