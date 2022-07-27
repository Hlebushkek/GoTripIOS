//
//  TripsTableView.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 18.11.2021.
//

import UIKit

class TripsListView: UIView {
    
    private var finishedLoadingInitialTableCells = false
    private var cellContentColor = UIColor.white
    let tableCellHeight: CGFloat = 80
    let tableView: UITableView = UITableView(frame: CGRect(), style: .insetGrouped)
    
    var blockInfos = LocalSavingSystem.LoadTripInfo(path: defaultsSavingKeys.tripInfoKey.rawValue)
    
    
    init(_ type: TripType) {
        var index = 0
        for block in blockInfos {
            if block.type != type {
                blockInfos.remove(at: index)
                index-=1
            }
            index+=1
        }
        
        super.init(frame: CGRect(x:0.0, y: 156.0, width: UIScreen.main.bounds.width, height: 80 + CGFloat(blockInfos.count) * tableCellHeight))
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: UIScreen.main.bounds.height - 156)
        tableView.backgroundColor = .white
        tableView.alpha = 0
        self.addSubview(tableView)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {self.tableView.alpha = 1}, completion: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
    }
}

extension TripsListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TripTableViewCell(info: blockInfos[indexPath.row], height: tableCellHeight, style: .default, reuseIdentifier: "cellID")
        return cell
    }
}
extension TripsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableCellHeight
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell1 = cell as! TripTableViewCell
        var lastInitialDisplayableCell = false
        var delay = 0.0
        
        if blockInfos.count > 0 && !finishedLoadingInitialTableCells {
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
        
        cell1.contentView.subviews[0].transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        cell1.contentView.subviews[0].alpha = 0
        UIView.animate(withDuration: 0.5, delay: delay, options: [.curveEaseInOut], animations: {
            cell1.contentView.subviews[0].transform = .identity
            cell1.contentView.subviews[0].alpha = 1
        }, completion: nil)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! TripTableViewCell
        cellContentColor = cell.contentView.subviews[0].backgroundColor!
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { cell.contentView.subviews[0].backgroundColor = .white}, completion: nil)
        return indexPath
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! TripTableViewCell

        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: { cell.contentView.subviews[0].backgroundColor = self.cellContentColor }, completion: nil)
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
    }
}
