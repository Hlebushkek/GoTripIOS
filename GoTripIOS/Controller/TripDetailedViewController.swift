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
    
    @IBOutlet weak var citiesStackView: UIStackView!
    
    @IBOutlet weak var placeFromLabel: UILabel!
    @IBOutlet weak var placeToLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    var placeFromField: UITextField?
    var placeToField: UITextField?
    var priceField: UITextField?
    var urlFieldField: UITextField?
    
    @IBOutlet weak var pathView: TripDotsView!
    
    @IBAction func animateView(_ sender: Any) {
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.topView.alpha = 0
            self.bottomView.alpha = 0
        }, completion: {_ in self.dismiss(animated: true, completion: nil)})
    }
    @IBAction func editButton(_ sender: Any) {
        placeFromField = UITextField()
        placeFromField?.text = placeFromLabel.text
        placeFromField?.alpha = 0
        
        placeToField = UITextField()
        placeToField?.text = placeToLabel.text
        placeToField?.alpha = 0
        
        priceField = UITextField()
        priceField?.text = priceLabel.text
        priceField?.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.placeFromLabel.alpha = 0
            self.placeToLabel.alpha = 0
            self.priceLabel.alpha = 0
        }, completion: {_ in
            self.citiesStackView.addSubview(self.placeFromField!)
            self.placeFromField?.frame = self.placeFromLabel.frame
            
            self.citiesStackView.addSubview(self.placeToField!)
            self.placeToField?.frame = self.placeToLabel.frame
            
            self.bottomView.addSubview(self.priceField!)
            self.priceField!.frame = self.priceLabel.frame
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.placeFromField?.alpha = 1
                self.placeToField?.alpha = 1
                self.priceField?.alpha = 1
            }, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
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
            
            placeFromLabel.text = info.placeFrom
            placeToLabel.text = info.placeTo
            priceLabel.text = info.price.description
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
