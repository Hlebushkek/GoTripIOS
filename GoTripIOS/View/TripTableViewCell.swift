//
//  TripTableViewCell.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 18.11.2021.
//

import UIKit
class TripTableViewCell: UITableViewCell {
    
    var cellView    = UIView()
    var tripTypeImg = UIImageView();
    var cityFrom    = UILabel();
    var cityTo      = UILabel();
    var price       = UILabel();


    init(info: TripInfo, height: CGFloat, style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //
        let screenToCell_K = 0.05
        let realCellWidth = UIScreen.main.bounds.width * (1-2*screenToCell_K)
        //
        let widthK = 0.9
        let heightK = 0.6
        let heightCenter = height * heightK / 2
        
        cellView.frame = CGRect(x: realCellWidth * (1-widthK)/2, y: height * (1-heightK)/2.0, width: realCellWidth * widthK, height: height * heightK)
        cellView.backgroundColor = .red
        cellView.layer.cornerRadius = 12
        self.selectionStyle = .none
        
        self.backgroundColor = TripColors.getStrongColor(num: info.type.rawValue)
        cellView.backgroundColor = TripColors.getColor(num: info.type.rawValue)
        tripTypeImg.tintColor = TripColors.getStrongColor(num: info.type.rawValue)
        
        switch info.type {
        case .Airplane:
            tripTypeImg.image = UIImage(systemName: "airplane")
            break
        case .Train:
            tripTypeImg.image = UIImage(systemName: "train.side.front.car")
            break
        case .Bus:
            tripTypeImg.image = UIImage(systemName: "bus")
            break
        case .Car:
            tripTypeImg.image = UIImage(systemName: "car")
            break
        }
        
        tripTypeImg.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        
        cityFrom.frame = CGRect(x: 56, y: 0, width: 32, height: 32)
        cityFrom.text = info.placeFrom
        cityFrom.numberOfLines = 0
        cityFrom.lineBreakMode = .byWordWrapping
        cityFrom.center.y = heightCenter
        cityFrom.textAlignment = .center
        
        cityTo.frame = CGRect(x: 96, y: 0, width: 32, height: 32)
        cityTo.text = info.placeTo
        cityTo.numberOfLines = 0
        cityTo.lineBreakMode = .byWordWrapping
        cityTo.center.y = heightCenter
        cityTo.textAlignment = .center
        
        price.frame = CGRect(x: cellView.frame.width - 64 - 8, y: 0, width: 64, height: 32)
        price.center.y = heightCenter
        price.text = info.price.description
        price.adjustsFontSizeToFitWidth = true
        price.textAlignment = .center

        contentView.addSubview(cellView)
        cellView.addSubview(tripTypeImg)
        cellView.addSubview(cityFrom)
        cellView.addSubview(cityTo)
        cellView.addSubview(price)
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[username]-[message]-|", options: nil, metrics: nil, views: viewsDict));
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[username]-|", options: nil, metrics: nil, views: viewsDict));
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[message]-|", options: nil, metrics: nil, views: viewsDict));
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
