//
//  AddBlockViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 08.11.2021.
//

import UIKit

class AddBlockViewController: UIViewController {
 
    var pickerData: [String] = ["Airplane", "Train", "Bus", "Car"]
    
    let dbManager = DBManager.shared
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var placeFrom: UITextField!
    @IBOutlet weak var placeTo: UITextField!
    @IBOutlet weak var price: UITextField!
    
    @IBAction func placeFromMapButton(_ sender: Any) {
        performSegue(withIdentifier: "SelectOnMap", sender: placeFrom)
    }
    @IBAction func placeToMapButton(_ sender: Any) {
        performSegue(withIdentifier: "SelectOnMap", sender: placeTo)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        guard isCorrectInput() && dbManager.isSignIn() else { return }
        
        guard let number = Float(price.text!) else {
            print("Can't create number")
            return
        }
        
        let trip = TripInfoModel()
        trip.placeFrom = self.placeFrom.text!
        trip.placeTo = self.placeTo.text!
        trip.price = TripPriceModel(number)
        trip.type = TripType(rawValue: self.pickerView.selectedRow(inComponent: 0)) ?? .airplane
        trip.dateAdded = TripUtilities.GetString(from: Date())
        
        self.dbManager.cloudAddTrip(trip)
        
        let parentVC = self.presentingViewController as? HomeViewController
        self.dismiss(animated: true, completion: {
            parentVC?.insert(trip, at: .end)
        })
    }
    
    func isCorrectInput() -> Bool {
        var alertsList = ""
        
        if placeFrom.text!.isEmpty {
            alertsList += " Place from;"
        }
        if placeTo.text!.isEmpty {
            alertsList += " Place to;"
        }
        if price.text!.isEmpty {
            alertsList += " Price;"
        }
        
        if (alertsList.isEmpty) {
            return true
        }
        else {
            let dialogMessage = UIAlertController(title: "Attention", message: "You have not entered the following positions:\(alertsList)", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            dialogMessage.addAction(okButton)
            self.present(dialogMessage, animated: true, completion: nil)
            return false
        }
    }
}

extension AddBlockViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        
        label.font = UIFont(name: "Arial", size: 24)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = pickerData[row]
        
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = true
        
        label.backgroundColor = TripUtilities.getColor(for: TripType(rawValue: row) ?? .airplane)

        return label
    }
}

extension AddBlockViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SelectOnMap") {
            if let navigationController = segue.destination as? UINavigationController {
                let toVC = navigationController.viewControllers[0] as? MapViewController
                toVC?.outputAddressLabel = (sender as? UITextField)
            }
        }
    }
}
