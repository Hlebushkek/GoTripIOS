//
//  TripDetailedViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 23.11.2021.
//

import UIKit

class TripDetailedViewController: UIViewController {
    var info: TripInfo?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    private var bottomGradientLayer = CAGradientLayer()
    
    @IBOutlet weak var placefrom: UILabel!
    @IBOutlet weak var placeTo: UILabel!
    @IBOutlet weak var price: UILabel!
        
    @IBOutlet weak var pathView: TripDotsView!
    
    @IBAction func animateView(_ sender: Any) {
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.topView.alpha = 0
            self.bottomView.alpha = 0
        }, completion: {_ in self.dismiss(animated: true, completion: nil)})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.topView.alpha = 1
            self.bottomView.alpha = 1
        }, completion: {_ in self.pathView.animatePath()})
    }
        
    func setInfo() {
        if let info = self.info {
            self.view.backgroundColor = TripColors.getColor(num: info.type.rawValue)
            //setBackgroundGradient()
            bottomView.alpha = 0
            
            topView.backgroundColor = TripColors.getStrongColor(num: info.type.rawValue)
            topView.alpha = 0
            
            placefrom.text = info.placeFrom
            placeTo.text = info.placeTo
            price.text = info.price.description
        }
    }
    
    func setBackgroundGradient() {
        bottomView.layer.addSublayer(bottomGradientLayer)
        
        bottomGradientLayer.colors = [TripColors.getStrongColor(num: info!.type.rawValue).cgColor, TripColors.getColor(num: info!.type.rawValue).cgColor]
        bottomGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        bottomGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.25)
        
        bottomGradientLayer.frame = bottomView.frame
        bottomGradientLayer.frame.origin = CGPoint(x: 0, y: 0)
    }
}
