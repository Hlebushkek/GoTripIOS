//
//  HomeTripBlock.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 11.10.2021.
//

import UIKit

class HomeTripBlockView: UIView {
    
    private var gradientLayer = CAGradientLayer()
    
    var city1L: UILabel = UILabel()
    var city2L: UILabel = UILabel()
    var priceL: UILabel = UILabel()
    
    var info: TripInfo
    
    init(info: TripInfo, num: Int, blockWidth: CGFloat, indent: CGFloat) {
        self.info = info
        
        var posX = indent
        if num % 2 == 1 {
            posX = UIScreen.main.bounds.width - blockWidth - indent
        }
        
        super.init(frame: CGRect(x: posX, y: 16.0 + CGFloat(num) * 96.0, width: blockWidth, height: 64))
        setGradient()
        setInfo()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGradient() {
        self.layer.addSublayer(gradientLayer)
        
        gradientLayer.colors = [TripColors.getColor(num: info.type.rawValue).cgColor, TripColors.getStrongColor(num: info.type.rawValue).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 10)
        
        gradientLayer.frame = self.frame
        gradientLayer.frame.origin = CGPoint(x: 0, y: 0)
        gradientLayer.cornerRadius = self.frame.width * 0.05
    }
    
    func setInfo() {
        
        //self.backgroundColor = TripColors.getColor(num: info.type.rawValue)
        self.layer.cornerRadius = 20;
        
        city1L.frame = CGRect(x: 16, y: 16, width: 48, height: 32)
        city1L.textAlignment = .center
        city1L.adjustsFontSizeToFitWidth = true
        city1L.text = info.placeFrom
        
        city2L.frame = CGRect(x: 80, y: 16, width: 48, height: 32)
        city2L.textAlignment = .center
        city2L.adjustsFontSizeToFitWidth = true
        city2L.text = info.placeTo
        
        priceL.frame = CGRect(x: UIScreen.main.bounds.width*0.85-48.0-16.0, y: 16.0, width: 48.0, height: 32.0)
        priceL.textAlignment = .center
        priceL.adjustsFontSizeToFitWidth = true
        priceL.text = info.price.description
        
        self.addSubview(city1L)
        self.addSubview(city2L)
        self.addSubview(priceL)
    }
    
    func setConstrains() {
        
    }
}
