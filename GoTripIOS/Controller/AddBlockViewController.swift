//
//  AddBlockViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 08.11.2021.
//

import UIKit

class AddBlockViewController: UIViewController {
 
    var pickerData: [String] = ["Airplane", "Train", "Bus", "Car"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var placeFrom: UITextField!
    @IBOutlet weak var placeTo: UITextField!
    @IBOutlet weak var price: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        if !checkInput() {return}
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2

        guard let number = formatter.number(from: price.text!) else {
            print("Can't create number")
            return
        }
        
        let decimal = number.decimalValue
        print(price.text!)
        print(number)
        print("Final : \(decimal)")
        var arr = LocalSavingSystem.LoadTripInfp(path: defaultsSavingKeys.tripInfoKey)!
        arr.append(TripInfo(placeFrom: placeFrom.text!, placeTo: placeTo.text!, price: decimal, type: TripType(rawValue: pickerView.selectedRow(inComponent: 0))!))
        LocalSavingSystem.SaveTripInfo(path: defaultsSavingKeys.tripInfoKey, info: arr)
        
        self.dismiss(animated: true)
    }
    
    func checkInput() -> Bool {
        
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
    /*func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 96
    }*/
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
        
        switch row {
        case 0:
            label.backgroundColor = UIColor(named: "AirplaneColor")
            break;
        case 1:
            label.backgroundColor = UIColor(named: "TrainColor")
            break;
        case 2:
            label.backgroundColor = UIColor(named: "BusColor")
            break;
        case 3:
            label.backgroundColor = UIColor(named: "CarColor")
            break;
        default:
            break;
        }

        return label
    }
}
