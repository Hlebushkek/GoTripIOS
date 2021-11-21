//
//  HomeTripBlock.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 11.10.2021.
//

import UIKit

class HomeTripBlockView: UIView {
    
    var city1L: UILabel = UILabel()
    var city2L: UILabel = UILabel()
    var priceL: UILabel = UILabel()
    
    var info: TripInfo
    
    init(info: TripInfo, num: Int) {
        self.info = info
        
        var posX = 16
        if num % 2 == 1 {
            posX = Int(UIScreen.main.bounds.width) - 320 - 16
        }
        
        super.init(frame: CGRect(x: posX, y: 16 + num * 96, width: 320, height: 64))
        setInfo()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInfo() {
        applyColor()
        self.layer.cornerRadius = 20;
        
        city1L.frame = CGRect(x: 16, y: 16, width: 64, height: 32)
        city1L.textAlignment = .center
        city1L.adjustsFontSizeToFitWidth = true
        city1L.text = info.placeFrom
        
        city2L.frame = CGRect(x: 96, y: 16, width: 64, height: 32)
        city2L.textAlignment = .center
        city2L.adjustsFontSizeToFitWidth = true
        city2L.text = info.placeTo
        
        priceL.frame = CGRect(x: 320-64-16, y: 16, width: 64, height: 32)
        priceL.textAlignment = .center
        priceL.adjustsFontSizeToFitWidth = true
        priceL.text = NSDecimalNumber(decimal: info.price).stringValue
        
        self.addSubview(city1L)
        self.addSubview(city2L)
        self.addSubview(priceL)
    }
    func applyColor() {
        switch info.type {
        case .Airplane:
            self.backgroundColor = UIColor(named: "AirplaneColor")
            break;
        case .Train:
            self.backgroundColor = UIColor(named: "TrainColor")
            break;
        case .Bus:
            self.backgroundColor = UIColor(named: "BusColor")
            break;
        case .Car:
            self.backgroundColor = UIColor(named: "CarColor")
            break;
        }
    }
    func setConstrains() {
        
    }
}
