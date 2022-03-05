//
//  HomeViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 13.10.2021.
//

import UIKit
import RealmSwift

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
    
    let dbManager = DBManager.shared
    
    let transitionToDetailedView = DetailedTripViewTransition()
    
    //var blockInfos1: [TripInfo] = LocalSavingSystem.LoadTripInfp(path: defaultsSavingKeys.tripInfoKey)!
    /*[
        TripInfo(placeFrom: "Kyiv", placeTo: "Lviv", price: TripPrice(1940), type: .Airplane),
        TripInfo(placeFrom: "Kyiv", placeTo: "Uzhorod", price: TripPrice(940.40), type: .Train),
        TripInfo(placeFrom: "Uzhorod", placeTo: "Poprad", price: TripPrice(623.35), type: .Bus),
        TripInfo(placeFrom: "Kyiv", placeTo: "Odessa", price: TripPrice(400), type: .Car),
        TripInfo(placeFrom: "Katowice", placeTo: "Oslo", price: TripPrice(1020.82), type: .Airplane)
    ]*/
    
    var blockInfos: [TripInfoModel] = []
    
    var gestureRecoginers: [TripInfoGestureRecognizer?] = []
    var filteredBlockInfosIndex: [Int] = []
    var existingBlockCount = 0
    var tripBlockViews: [HomeTripBlockView?] = []
    
    let tripBlockIndent = UIScreen.main.bounds.width * 0.03
    let tripBlockWidth = UIScreen.main.bounds.width * 0.85
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        searchBar.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        DispatchQueue.main.async {
            if let user = LocalSavingSystem.getUserInfo() {
                self.dbManager.signIn(email: user.email, password: user.password)
            }
            
            guard let user = self.dbManager.getUser() else { return }
            let userRealm = try! Realm(configuration: user.configuration(partitionValue: "123"))
            let models = userRealm.objects(TripInfoModel.self).where{$0.ownerID == user.id}
            self.blockInfos = Array(models).sorted {
                DBManager.stringToDate($0.dateAdded) > DBManager.stringToDate($1.dateAdded)
            }
        
            self.tripBlockViews = [HomeTripBlockView?](repeating: nil, count: self.blockInfos.count)
            self.gestureRecoginers = [TripInfoGestureRecognizer?](repeating: nil, count: self.blockInfos.count)
            
            self.existingBlockCount = self.blockInfos.count
            for index in 0...self.blockInfos.count-1 {
                let blockview = HomeTripBlockView(info: self.blockInfos[index], num: index, blockWidth: self.tripBlockWidth, indent: self.tripBlockIndent);
                self.addTapGesture(blockview, index)
                self.ContentView.addSubview(blockview)
                self.tripBlockViews[index] = blockview
                self.filteredBlockInfosIndex.append(index)
                
                blockview.alpha = 0
                UIView.animate(withDuration: 0.25, delay: Double(index)*0.1, options: [], animations: {
                    blockview.alpha = 1
                }, completion: nil)
            }
            
            self.scrollViewContainerHeightConstraint = NSLayoutConstraint(item: self.ContentView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(16 + 96 * self.blockInfos.count))
            NSLayoutConstraint.activate([self.scrollViewContainerHeightConstraint])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if blockInfos.count < 1 {
            self.viewDidLoad()
        }
        
        if !dbManager.isSignIn() {
            for i in 0..<tripBlockViews.count {
                if let rec = gestureRecoginers[i] {
                    tripBlockViews[i]?.removeGestureRecognizer(rec)
                }
                tripBlockViews[i]?.removeFromSuperview()
                tripBlockViews[i] = nil
            }
            for i in 0..<gestureRecoginers.count {
                gestureRecoginers[i] = nil
            }
            blockInfos.removeAll()
            
            resizeView()
        }
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
                        self.gestureRecoginers[index]!.block = nil
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
            //From end to start push apart blocks and then create new blocks
            var addedBlockCount = filteredBlockInfosIndex.count - existingBlockCount
            var slidingDelay = 0
            existingBlockCount = 0
            
            for index in stride(from: blockInfos.count-1, to: -1, by: -1) {
                if filteredBlockInfosIndex.contains(index) && tripBlockViews[index] == nil {
                    let blockview = HomeTripBlockView(info: blockInfos[index], num: filteredBlockInfosIndex.count-1-existingBlockCount, blockWidth: tripBlockWidth, indent: tripBlockIndent);
                    addTapGesture(blockview, index)
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
                UIView.animate(withDuration: 0.2, delay: CGFloat(index) * 0.1, options: [], animations: {view!.frame.origin.x = (index % 2 == 0) ? 16 : (UIScreen.main.bounds.width - self.tripBlockWidth - self.tripBlockIndent)
                    index+=1}, completion: nil)
            }
        }
    }
    func resizeView() {
        self.scrollViewContainerHeightConstraint.constant = CGFloat(self.existingBlockCount * 96)
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { self.view.layoutIfNeeded()}, completion: nil)
    }
    func insertBlockInfo(info: TripInfoModel) {
        searchBar.text = ""
        
        blockInfos.insert(info, at: 0)
        tripBlockViews.insert(nil, at: 0)
        
        filteredBlockInfosIndex = []

        var index = 0
        for _ in blockInfos {
            filteredBlockInfosIndex.append(index)
            index+=1
        }
        
        updateTripBlockViews()
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
                String(describing: block.price).uppercased().contains(searchText.uppercased()) ||
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

extension HomeViewController {
    func addTapGesture(_ block: HomeTripBlockView, _ index: Int) {
        let tapGR = TripInfoGestureRecognizer(target: self, action: #selector(self.tapOnBlock))
        tapGR.block = block
        block.addGestureRecognizer(tapGR)
        block.isUserInteractionEnabled = true
        
        gestureRecoginers[index] = tapGR
    }
    @objc func tapOnBlock(sender: TripInfoGestureRecognizer) {
        print("Tapped on \(sender.block!.info)")
        
        let tripVC = self.storyboard?.instantiateViewController(withIdentifier: "tripdetailed") as! TripDetailedViewController
        tripVC.info = sender.block!.info
        
        transitionToDetailedView.tripType = sender.block!.info.type
        transitionToDetailedView.startPoint.x = sender.block!.center.x
        transitionToDetailedView.startPoint.y = sender.block!.center.y + view.subviews[2].frame.origin.y - scrollView.contentOffset.y
        
        tripVC.transitioningDelegate = self
        tripVC.modalPresentationStyle = .custom
        
        present(tripVC, animated: true)
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionToDetailedView.transitionMode = .present
        
        return transitionToDetailedView
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionToDetailedView.transitionMode = .dismiss
        
        return transitionToDetailedView
    }
}
