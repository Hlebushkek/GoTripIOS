//
//  RailViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 16.11.2021.
//

import UIKit

class TripListViewController: UIViewController {
    
    @IBInspectable public var tripTypeNum: Int = 0 {
        didSet {
            if tripTypeNum > 3 {tripTypeNum = 3}
            else if tripTypeNum < 0 {tripTypeNum = 0}
            tripType = TripType(rawValue: tripTypeNum)!
        }
    }
    @IBOutlet weak var tripTypeNameLabel: UILabel!
    
    var tripTypeName = ""
    var tripType: TripType = .Airplane
    var blockInfos = LocalSavingSystem.LoadTripInfp(path: defaultsSavingKeys.tripInfoKey)!
    var tripsListView: TripsListView?
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func presentTable() {
        tripsListView = TripsListView(tripType)
        self.view.addSubview(tripsListView!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripTypeNameLabel.text = tripTypeName
        //To fix stupid Decimal
        /*let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        var index = 0
        for block in blockInfos {
            let price = block.price
            let doublePrice = Double(truncating: NSDecimalNumber(decimal: price))
            var formatteddouble = round(doublePrice * 100) / 100
            if formatteddouble == 9.96 {
                formatteddouble = 9
            }
            print(formatteddouble)
            let priceStr = "\(formatteddouble)"
            let number = formatter.number(from: priceStr)
            let decimal = number!.decimalValue
            print(decimal)
            blockInfos[index] = TripInfo(placeFrom: block.placeFrom, placeTo: block.placeTo, price: decimal, type: block.type)
            index+=1
        }
        LocalSavingSystem.SaveTripInfo(path: defaultsSavingKeys.tripInfoKey, info: blockInfos)*/
    }
}
