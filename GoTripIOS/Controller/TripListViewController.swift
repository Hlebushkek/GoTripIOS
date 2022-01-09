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
    }
}
