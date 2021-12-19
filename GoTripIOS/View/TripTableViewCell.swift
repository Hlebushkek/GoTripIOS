//
//  TripTableViewCell.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 18.11.2021.
//

import UIKit
class TripTableViewCell: UITableViewCell {
    
    var cellView    = UIView()
    var tripTypeImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 24));
    var cityFrom    = UILabel(frame: CGRect(x: 48, y: 0, width: 80, height: 64));
    var cityTo      = UILabel(frame: CGRect(x: 144, y: 0, width: 80, height: 64));
    var price       = UILabel(frame: CGRect(x: 240, y: 0, width: 64, height: 64));


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
        
        
        switch info.type {
        case .Airplane:
            self.backgroundColor = UIColor(named: "AirplaneColorStrong")
            cellView.backgroundColor = UIColor(named: "AirplaneColor")
            tripTypeImg.image = UIImage(systemName: "airplane")
            tripTypeImg.tintColor = UIColor(named: "AirplaneColorStrong")
            break
        case .Train:
            self.backgroundColor = UIColor(named: "TrainColorStrong")
            cellView.backgroundColor = UIColor(named: "TrainColor")
            tripTypeImg.image = UIImage(systemName: "train.side.front.car")
            tripTypeImg.tintColor = UIColor(named: "TrainColorStrong")
            break
        case .Bus:
            self.backgroundColor = UIColor(named: "BusColorStrong")
            cellView.backgroundColor = UIColor(named: "BusColor")
            tripTypeImg.image = UIImage(systemName: "bus")
            tripTypeImg.tintColor = UIColor(named: "BusColorStrong")
            break
        case .Car:
            self.backgroundColor = UIColor(named: "CarColorStrong")
            cellView.backgroundColor = UIColor(named: "CarColor")
            tripTypeImg.image = UIImage(systemName: "car")
            tripTypeImg.tintColor = UIColor(named: "CarColorStrong")
            break
        }
        
        tripTypeImg.center = CGPoint(x: tripTypeImg.frame.width / 2.0, y: heightCenter)
        
        cityFrom.text = info.placeFrom
        cityFrom.numberOfLines = 0
        cityFrom.lineBreakMode = .byWordWrapping
        cityFrom.center.y = heightCenter
        cityFrom.textAlignment = .center
        
        cityTo.text = info.placeTo
        cityTo.numberOfLines = 0
        cityTo.lineBreakMode = .byWordWrapping
        cityTo.center.y = heightCenter
        cityTo.textAlignment = .center
        
        price.text = "\(info.price)"
        price.numberOfLines = 0
        price.lineBreakMode = .byWordWrapping
        price.center.y = heightCenter
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
