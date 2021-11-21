//
//  CornerExtentionUIVIew.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 30.10.2021.
//

import UIKit

@IBDesignable
class RoundUIView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    /*@IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var cornerMaxMax: Bool = false {
        didSet {
            self.layer.maskedCorners.insert(.layerMaxXMaxYCorner)
        }
    }
    @IBInspectable var cornerMaxMin: Bool = false {
        didSet {
            self.layer.maskedCorners.insert(.layerMaxXMinYCorner)
        }
    }
    @IBInspectable var cornerMinMax: Bool = false {
        didSet {
            self.layer.maskedCorners.insert(.layerMinXMaxYCorner)
        }
    }
    @IBInspectable var cornerMinMin: Bool = false {
        didSet {
            self.layer.maskedCorners.insert(.layerMinXMinYCorner)
        }
    }*/

}
