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
    
    
    var blockInfos: [TripInfo] = LocalSavingSystem.LoadTripInfp(path: defaultsSavingKeys.tripInfoKey)!
    /*[
        TripInfo(placeFrom: "Kyiv", placeTo: "Lviv", price: 1920, type: .Airplane),
        TripInfo(placeFrom: "Kyiv", placeTo: "Uzhorod", price: 940.40, type: .Train),
        TripInfo(placeFrom: "Uzhorod", placeTo: "Poprad", price: 623.35, type: .Bus),
        TripInfo(placeFrom: "Kyiv", placeTo: "Odessa", price: 400, type: .Car),
        TripInfo(placeFrom: "Katowice", placeTo: "Oslo", price: 1020.82, type: .Airplane)
    ]*/
    var filteredBlockInfosIndex: [Int] = []
    var existingBlockCount = 0
    var tripBlockViews: [HomeTripBlockView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        searchBar.delegate = self
        
        tripBlockViews = [HomeTripBlockView?](repeating: nil, count: blockInfos.count)
        existingBlockCount = blockInfos.count
        for index in 0...blockInfos.count-1 {
            let blockview = HomeTripBlockView(info: blockInfos[index], num: index);
            addTapGesture(blockview, blockInfos[index])
            ContentView.addSubview(blockview)
            tripBlockViews[index] = blockview
            filteredBlockInfosIndex.append(index)
        }
        
        scrollViewContainerHeightConstraint = NSLayoutConstraint(item: ContentView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(16 + 96 * blockInfos.count))
        NSLayoutConstraint.activate([scrollViewContainerHeightConstraint])
        
        //updateTripBlockViews()
    }
    func updateTripBlockViews() {
        if (existingBlockCount > filteredBlockInfosIndex.count) {
            //Swiping block
            existingBlockCount = 0
            for index in 0...tripBlockViews.count-1 {
                if !filteredBlockInfosIndex.contains(index) && tripBlockViews[index] != nil {
                    UIView.animate(withDuration: 0.2, delay: Double(existingBlockCount) * 0.05, options: [], animations: {
                        if self.tripBlockViews[index]!.frame.origin.x > 0 && self.tripBlockViews[index]!.frame.origin.x < UIScreen.main.bounds.width {
                            var transX = UIScreen.main.bounds.width
                            if self.existingBlockCount % 2 == 0 {transX*=(-1)}
                            self.tripBlockViews[index]!.transform = CGAffineTransform(translationX: transX, y: 0)
                        }
                    }, completion: nil)
                    existingBlockCount+=1
                }
            }
            //Collapse remaining and deleting removed blocks
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(existingBlockCount) * 0.1) {
                self.existingBlockCount = 0
                for index in 0...self.tripBlockViews.count-1 {
                    if !self.filteredBlockInfosIndex.contains(index) && self.tripBlockViews[index] != nil {
                        self.tripBlockViews[index]!.removeFromSuperview()
                        self.tripBlockViews[index] = nil
                    }
                    else if self.filteredBlockInfosIndex.contains(index) {
                        UIView.animate(withDuration: 0.2, delay: Double(self.existingBlockCount) * 0.1, options: [], animations: {
                            self.tripBlockViews[index]!.frame.origin.y = CGFloat(16 + self.existingBlockCount * 96)
                            self.existingBlockCount+=1
                        }, completion: nil)
                    }
                }
                self.recalcX()
                self.resizeView()
            }
            //
        } else if (existingBlockCount < filteredBlockInfosIndex.count) {
            //From end to start push apart blocks and create new block
            var addedBlockCount = filteredBlockInfosIndex.count - existingBlockCount
            var slidingDelay = 0
            existingBlockCount = 0
            for index in stride(from: blockInfos.count-1, to: -1, by: -1) {
                if filteredBlockInfosIndex.contains(index) && tripBlockViews[index] == nil {
                    let blockview = HomeTripBlockView(info: blockInfos[index], num: filteredBlockInfosIndex.count-1-existingBlockCount);
                    addTapGesture(blockview, blockInfos[index])
                    ContentView.addSubview(blockview)
                    blockview.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * pow(-1.0, CGFloat(index)), y: 0)
                    tripBlockViews[index] = blockview
                    addedBlockCount-=1
                    existingBlockCount+=1
                } else if tripBlockViews[index] != nil {
                    slidingDelay+=1
                    existingBlockCount+=1
                    UIView.animate(withDuration: 0.2, delay: Double(slidingDelay) * 0.05, options: [], animations: { self.tripBlockViews[index]!.frame.origin.y += CGFloat(96 * addedBlockCount)}, completion: nil)
                }
            }
            
            //Place blocks on correct X
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(slidingDelay) * 0.05) {
                for index in stride(from: self.filteredBlockInfosIndex.count-1, to: -1, by: -1) {
                    UIView.animate(withDuration: 0.2, delay: Double(self.filteredBlockInfosIndex.count-1 - index) * 0.05, options: [], animations: {
                        self.tripBlockViews[self.filteredBlockInfosIndex[index]]?.transform = .identity
                    }, completion: nil)
                }
                self.existingBlockCount = self.filteredBlockInfosIndex.count
                self.recalcX()
                self.resizeView()
            }
            //
        }
    }
    func recalcX() {
        var index = 0
        for view in tripBlockViews {
            if view != nil {
                UIView.animate(withDuration: 0.2, delay: CGFloat(index) * 0.1, options: [], animations: {view!.frame.origin.x = (index % 2 == 0) ? 16 : (UIScreen.main.bounds.width - 320 - 16)
                    index+=1}, completion: nil)
            }
        }
    }
    func resizeView() {
        self.scrollViewContainerHeightConstraint.constant = CGFloat(self.existingBlockCount * 96)
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { self.view.layoutIfNeeded()}, completion: nil)
    }
    func addTapGesture(_ block: UIView, _ info: TripInfo) {
        let tapGR = TripInfoGestureRecognizer(target: self, action: #selector(self.tapOnBlock))
        tapGR.info = info
        block.addGestureRecognizer(tapGR)
        block.isUserInteractionEnabled = true
    }
    @objc func tapOnBlock(sender: TripInfoGestureRecognizer) {
        print("Tapped on \(sender.info)")
        let tripVC = self.storyboard?.instantiateViewController(withIdentifier: "tripdetailed") as! TripDetailedViewController

        tripVC.modalPresentationStyle = .pageSheet
        self.present(tripVC, animated: true, completion: nil)
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
        filteredBlockInfosIndex = []

        var index = 0
        for block in blockInfos {
            if (block.placeFrom.uppercased().contains(searchText.uppercased()) ||
                block.placeTo.uppercased().contains(searchText.uppercased()) ||
                "\(block.price)".uppercased().contains(searchText.uppercased()) ||
                searchText.count == 0) {
                filteredBlockInfosIndex.append(index)
            }
            index+=1
        }
        //print("\(filteredBlockInfosIndex)")
        updateTripBlockViews()
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
