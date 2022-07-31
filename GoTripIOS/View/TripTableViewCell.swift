//
//  TripTableViewCell.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 18.11.2021.
//

import UIKit
class TripTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tripTypeImage: UIImageView!
    
    @IBOutlet weak var placeFromLabel: UILabel!
    @IBOutlet weak var placeToLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    public func updateRepresentation(for info: TripInfoModel) {
        self.layer.cornerRadius = 12
        self.selectionStyle = .none
        
        self.backgroundColor = TripUtilities.getStrongColor(for: info.type)
        self.contentView.backgroundColor = TripUtilities.getColor(for: info.type)
        self.contentView.subviews[0].layer.cornerRadius = 8
        
        tripTypeImage.tintColor = TripUtilities.getStrongColor(for: info.type)
        tripTypeImage.image = TripUtilities.getImage(for: info.type)
        
        placeFromLabel.text = info.placeFrom
        placeFromLabel.numberOfLines = 0
        placeFromLabel.lineBreakMode = .byWordWrapping
        
        placeToLabel.text = info.placeTo
        placeToLabel.numberOfLines = 0
        placeToLabel.lineBreakMode = .byWordWrapping
        
        priceLabel.text = info.price?.description
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.textAlignment = .center
    }
    
}
