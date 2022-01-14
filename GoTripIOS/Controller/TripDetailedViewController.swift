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
    
    @IBOutlet var editableLabels: [UILabel]!
    var editableFields: [UITextField] = []
    
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

        if (editableFields.isEmpty)
        {
            for label in editableLabels {
                let field = UITextField()
                editableFields.append(field)
                label.superview!.addSubview(field)
                
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    label.alpha = 0
                }, completion: {_ in
                    field.alpha = 0
                    field.frame = label.frame
                    field.text = label.text
                    UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                        field.alpha = 1
                    }, completion: nil)
                })
            }
        }
        else
        {
            for index in 0..<editableLabels.count-1 {
                editableLabels[index].text = editableFields[index].text
                editableFields[index].removeFromSuperview()
                
                editableLabels[index].alpha = 1
            }
            editableFields.removeAll()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInfo()
        hideKeyboardWhenTappedAround()
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
            
            editableLabels[0].text = info.placeFrom
            editableLabels[1].text = info.placeTo
            editableLabels[2].text = info.price.description
            editableLabels[3].text = "www.orderticket.com/abc/cba"
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
