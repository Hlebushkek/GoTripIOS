//
//  TripDotsView.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 26.11.2021.
//

import UIKit

class TripDotsView: UIView {
    
    var circle1: UIView = UIView()
    var circle2: UIView = UIView()
    var connection: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        instantiatePath()
    }
    
    func instantiatePath() {
        self.frame.size = CGSize(width: UIScreen.main.bounds.width, height: self.frame.size.height)
        
        circle1 = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        circle1.center = CGPoint(x: 16, y: self.bounds.height/2)
        circle1.backgroundColor = .blue
        circle1.layer.cornerRadius = 8
        
        circle2 = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        circle2.center = CGPoint(x: self.bounds.width - 16 - 16, y: self.bounds.height/2)
        circle2.backgroundColor = .blue
        circle2.layer.cornerRadius = 8
        
        connection = UIView(frame: CGRect(x: 0, y: 0, width: circle2.center.x - circle1.center.x, height: 8))
        connection.transform = CGAffineTransform(scaleX: 0.0001, y: 1)
        connection.frame.origin = CGPoint(x: circle1.center.x, y: circle1.center.y - connection.bounds.height/2)
        connection.backgroundColor = .blue
        
        self.addSubview(circle1)
        self.addSubview(circle2)
        self.addSubview(connection)
        
        circle1.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        circle2.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    func animatePath() {
        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
            self.circle1.transform = .identity
        }, completion: {_ in
            UIView.animate(withDuration: 0.75, delay: 0, options: [], animations: {
                self.connection.transform = .identity
                self.connection.frame.origin = CGPoint(x: self.circle1.center.x, y:  self.connection.frame.origin.y)
            }, completion: {_ in
                UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                    self.circle2.transform = .identity
                }, completion: nil)
            })
        })
    }
}
