//
//  TripDetailedViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 23.11.2021.
//

import UIKit

class TripDetailedViewController: UIViewController {
    var info: TripInfo?
    
    @IBOutlet weak var placefrom: UILabel!
    @IBOutlet weak var placeTo: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBAction func animateView(_ sender: Any) {
        self.view.frame = CGRect(x: 0, y: 0, width: 360, height:560)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let info = self.info {
            placefrom.text = info.placeFrom
            placeTo.text = info.placeTo
            price.text = NSDecimalNumber(decimal: info.price).stringValue
            
            let newLayer = CAGradientLayer()
            //newLayer.colors = [UIColor(named: "AirplaneColor")!.cgColor, UIColor(named: "AirplaneColorStrong")!.cgColor]
            newLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
            newLayer.frame = gradientView.frame
            newLayer.frame.origin = CGPoint(x: 0, y: 0)
            newLayer.cornerRadius = 16
            newLayer.startPoint = CGPoint(x: 0, y: 0)
            newLayer.endPoint = CGPoint(x: 1, y: 1)
            
            
            let gradientAnimation = CABasicAnimation(keyPath: "locations")
            gradientAnimation.fromValue = [0.0, 0.25]
            gradientAnimation.toValue = [0.75, 1.0]
            gradientAnimation.duration = 3.0
            gradientAnimation.repeatCount = Float.infinity

            newLayer.add(gradientAnimation, forKey: nil)
            
            gradientView.layer.addSublayer(newLayer)
            
        }
    }
}
