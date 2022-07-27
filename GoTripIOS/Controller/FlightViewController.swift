//
//  FlightTableView.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 30.10.2021.
//

import UIKit

class FlightViewController: UIViewController {
    
    let cellId = "tripCell"
    var blockInfos = LocalSavingSystem.LoadTripInfo(path: defaultsSavingKeys.tripInfoKey.rawValue)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var index = 0
        for block in blockInfos {
            if block.type != .Airplane {
                blockInfos.remove(at: index)
                index-=1
            }
            index+=1
        }
        
        backButton.layer.cornerRadius = 6
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension FlightViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        
        cell.contentView.subviews[0].layer.cornerRadius = 16
        cell.contentView.subviews[0].layer.masksToBounds = true
        
        cell.textLabel?.text = blockInfos[indexPath.row].placeFrom + " " + blockInfos[indexPath.row].placeTo
        cell.imageView?.image = UIImage(systemName: "airplane")
        return cell
    }
}
extension FlightViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
