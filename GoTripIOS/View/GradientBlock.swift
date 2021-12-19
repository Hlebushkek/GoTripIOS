//
//  GradientBlock.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 03.12.2021.
//

import UIKit

class GradientBlock: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, type: Int) {
        super.init(frame: frame)
        
        applyGradient(type: type)
    }
    
    private func applyGradient(type: Int) {
        self.layer.addSublayer(gradientLayer)
        
        gradientLayer.colors = [TripColors.getColor(num: type).cgColor, TripColors.getStrongColor(num: type).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.frame
        gradientLayer.frame.origin = CGPoint(x: 0, y: 0)
        gradientLayer.cornerRadius = self.frame.width * 0.05
    }
}
