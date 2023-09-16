//
//  RailViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 16.11.2021.
//

import UIKit

class TripListViewController: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var typeImage: UIImageView?
    
    @IBOutlet weak var tableView: UITableView?
    
    private var finishedLoadingInitialTableCells = false
    private var cellContentColor: UIColor? = .white
    
    var tripType: TripType = .airplane
    
    private var dbManager = DBManager.shared
    private var trips: [TripInfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        typeLabel?.text = tripType.title()
        typeImage?.image = tripType.image()
        
        tableView?.alpha = 0
        dbManager.fetchTrips { [weak self] infos in
            self?.trips = infos.filter { $0.type == self?.tripType }
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                self?.tableView?.alpha = 1
            }, completion: nil)
            self?.tableView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        typeImage?.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.typeImage?.alpha = 1
        })
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension TripListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tripsByTypeTableCell", for: indexPath) as? TripTableViewCell else { return UITableViewCell() }
        
        cell.updateRepresentation(for: trips[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TripTableViewCell else { return }
        var lastInitialDisplayableCell = false
        var delay = 0.0
        
        if trips.count > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            delay = 0.1 * Double(indexPath.row)
        }
        
        cell.contentView.subviews[0].transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        cell.contentView.subviews[0].alpha = 0
        UIView.animate(withDuration: 0.5, delay: delay, options: [.curveEaseInOut], animations: {
            cell.contentView.subviews[0].transform = .identity
            cell.contentView.subviews[0].alpha = 1
        }, completion: nil)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TripTableViewCell else { return nil }
        cellContentColor = cell.contentView.backgroundColor
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            cell.contentView.subviews[0].backgroundColor = .white
        }, completion: nil)
        
        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as? TripTableViewCell
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            cell?.contentView.subviews[0].backgroundColor = self.cellContentColor
        }, completion: nil)
        
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
