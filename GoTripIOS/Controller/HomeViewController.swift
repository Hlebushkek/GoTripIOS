//
//  HomeViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 13.10.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    private var scrollViewContainerHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBAction func airplaneButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "ShowTableView", sender: TripType.Airplane)
    }
    @IBAction func trainButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "ShowTableView", sender: TripType.Train)
    }
    @IBAction func busButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "ShowTableView", sender: TripType.Bus)
    }
    @IBAction func carButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "ShowTableView", sender: TripType.Car)
    }
    
    
    var blockInfos: [TripInfo] = [
        /*TripInfo(placeFrom: "Kyiv", placeTo: "Lviv", price: 1920, type: .Airplane),
        TripInfo(placeFrom: "Kyiv", placeTo: "Uzhorod", price: 940.40, type: .Train),
        TripInfo(placeFrom: "Uzhorod", placeTo: "Poprad", price: 623.35, type: .Bus),
        TripInfo(placeFrom: "Kyiv", placeTo: "Odessa", price: 400, type: .Car),
        TripInfo(placeFrom: "Katowice", placeTo: "Oslo", price: 1020.82, type: .Airplane)*/
    ]
    var filteredblockInfos: [TripInfo] = []
    var tripBlockViews: [HomeTripBlockView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        searchBar.delegate = self
        
        /*for index in 0...blockInfos.count-1 {
            let blockview = HomeTripBlockView(info: blockInfos[index], num: index);
            ContentView.addSubview(blockview)
        }
        
        for index in blockInfos.count...9 {
            let block = TripInfo.example()
            blockInfos.append(block)
            let blockview = HomeTripBlockView(info: blockInfos[index], num: index);
            ContentView.addSubview(blockview)
        }*/
        
        blockInfos = LocalSavingSystem.LoadTripInfp(path: defaultsSavingKeys.tripInfoKey)!
        filteredblockInfos = blockInfos
        
        let subview = self.view.subviews[2].subviews[0].subviews[0]
        scrollViewContainerHeightConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(16 + 96 * filteredblockInfos.count))
        NSLayoutConstraint.activate([scrollViewContainerHeightConstraint])
        
        replaceTripBlockViews()
    }
    func replaceTripBlockViews() {
        var blocksToDelete = 0
        if tripBlockViews.count > 0 {
            var index = 0
            for block in tripBlockViews {
                UIView.animate(withDuration: 0.2, delay: Double(index) * 0.1, options: [.curveEaseIn], animations: {
                    var transX = UIScreen.main.bounds.width
                    if index % 2 == 0 {transX*=(-1)}
                    
                    block.transform = CGAffineTransform(translationX: transX, y: 0)
                }, completion: {_ in block.removeFromSuperview()})
                index+=1
            }
            blocksToDelete = tripBlockViews.count
            tripBlockViews.removeAll()
        }
        
        if filteredblockInfos.count < 1 { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(blocksToDelete) * 0.1) {
            for index in 0...self.filteredblockInfos.count-1 {
                let blockview = HomeTripBlockView(info: self.filteredblockInfos[self.filteredblockInfos.count-1 - index], num: index);
                self.ContentView.addSubview(blockview)
                self.tripBlockViews.append(blockview)
            }
            
            self.scrollViewContainerHeightConstraint.constant = CGFloat(16 + 96 * self.tripBlockViews.count)
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > 50 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.tabBarView.alpha = 0
            })
        }
        else if scrollView.contentOffset.y < 50 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.tabBarView.alpha = 1
            })
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredblockInfos = []
        
        for block in blockInfos {
            if (block.placeFrom.uppercased().contains(searchText.uppercased()) ||
                block.placeTo.uppercased().contains(searchText.uppercased()) ||
                "\(block.price)".uppercased().contains(searchText.uppercased()) ||
                searchText.count == 0) {
                filteredblockInfos.append(block)
            }
        }
        
        replaceTripBlockViews()
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowTableView") {
            if let vc = segue.destination as? TripListViewController {
                switch sender as! TripType {
                case .Airplane:
                    vc.tripTypeNum = 0
                    vc.tripTypeName = "Airplane"
                    break;
                case .Train:
                    vc.tripTypeNum = 1
                    vc.tripTypeName = "Train"
                    break
                case .Bus:
                    vc.tripTypeNum = 2
                    vc.tripTypeName = "Bus"
                    break;
                case .Car:
                    vc.tripTypeNum = 3
                    vc.tripTypeName = "Car"
                    break
                }
            }
        }
    }
}
