//
//  HomeViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 13.10.2021.
//

import UIKit

class HomeViewController: UIViewController, ObservingProtocol {
    
    enum Constants {
        static let homeTripTableCellViewNibName = "HomeTripTableViewCell"
        static let showListsSegueIdentifier = "ShowTableView"
    }

    private var searchController: UISearchController?
    private var searchText: String {
        searchController?.searchBar.text ?? ""
    }

    @IBOutlet weak var tabBarView: UIView? {
        didSet { tabBarView?.layer.cornerRadius = 8 }
    }
    @IBOutlet weak var tableView: UITableView?
    
    @IBAction func tripTypeButtonWasPressed(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        performSegue(withIdentifier: Constants.showListsSegueIdentifier, sender: TripType(rawValue: button.tag))
    }
    
    private let dbManager = DBManager.shared
    
    private let transitionToDetailedView = DetailedTripViewTransition()
    
    private var trips: [TripInfoModel] = [] {
        didSet {
            filter(text: searchText)
        }
    }
    private var filteredTrips: [TripInfoModel] = [] {
        didSet {
            tableView?.reloadData()
            tableView?.beginUpdates()
            tableView?.setNeedsDisplay()
            tableView?.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbManager.addListener(self)
        
        hideKeyboardWhenTappedAround()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.secondarySystemBackground
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView?.register(UINib(nibName: Constants.homeTripTableCellViewNibName, bundle: .main), forCellReuseIdentifier: Constants.homeTripTableCellViewNibName)
        
        updateTabBar()
    }
    
    deinit {
        dbManager.removeListener(self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateTabBar()
    }
    
    private func reloadList() {
        dbManager.getTrips { [weak self] trips in
            self?.trips = trips
        }
    }
    
//    func loadTripInfos() {
//        guard let user = LocalSavingSystem.userInfo else { return }
//        dbManager.signIn(email: user.email, password: user.password, onSuccess: {
//            self.dbManager.getTripInfos(onSuccess: { infos in
//
//                self.blockInfos = infos
//
//                self.tripBlockViews = [HomeTripBlockView?](repeating: nil, count: infos.count)
//                self.gestureRecoginers = [TripInfoGestureRecognizer?](repeating: nil, count: infos.count)
//
//                self.existingBlockCount = self.blockInfos.count
//                for index in 0..<self.blockInfos.count {
//                    let blockview = HomeTripBlockView(info: self.blockInfos[index], num: index, blockWidth: self.tripBlockWidth, indent: self.tripBlockIndent);
//                    self.addTapGesture(blockview, index)
//                    self.ContentView.addSubview(blockview)
//                    self.tripBlockViews[index] = blockview
//                    self.filteredBlockInfosIndex.append(index)
//
//                    blockview.alpha = 0
//                    UIView.animate(withDuration: 0.25, delay: Double(index)*0.1, options: [], animations: {
//                        blockview.alpha = 1
//                    }, completion: nil)
//                }
//
//                self.scrollViewContainerHeightConstraint = NSLayoutConstraint(item: self.ContentView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(16 + 96 * self.blockInfos.count))
//                NSLayoutConstraint.activate([self.scrollViewContainerHeightConstraint])
//            })
//        })
//    }
    
//    func updateTripBlockViews() {
//        if (existingBlockCount > filteredBlockInfosIndex.count) {
//            //Swiping block
//            existingBlockCount = 0
//            for index in 0...tripBlockViews.count-1 {
//                if !filteredBlockInfosIndex.contains(index) && tripBlockViews[index] != nil {
//                    UIView.animate(withDuration: 0.2, delay: Double(existingBlockCount) * 0.05, options: [], animations: {
//                        if self.tripBlockViews[index]!.frame.origin.x > 0 && self.tripBlockViews[index]!.frame.origin.x < UIScreen.main.bounds.width {
//                            var transX = UIScreen.main.bounds.width
//                            if self.existingBlockCount % 2 == 0 {transX*=(-1)}
//                            self.tripBlockViews[index]!.transform = CGAffineTransform(translationX: transX, y: 0)
//                        }
//                    }, completion: nil)
//                    existingBlockCount+=1
//                }
//            }
//            //Collapse remaining and deleting removed blocks
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(existingBlockCount) * 0.1) {
//                self.existingBlockCount = 0
//                for index in 0...self.tripBlockViews.count-1 {
//                    if !self.filteredBlockInfosIndex.contains(index) && self.tripBlockViews[index] != nil {
//                        self.gestureRecoginers[index]!.block = nil
//                        self.tripBlockViews[index]!.removeFromSuperview()
//                        self.tripBlockViews[index] = nil
//                    }
//                    else if self.filteredBlockInfosIndex.contains(index) {
//                        UIView.animate(withDuration: 0.2, delay: Double(self.existingBlockCount) * 0.1, options: [], animations: {
//                            self.tripBlockViews[index]!.frame.origin.y = CGFloat(16 + self.existingBlockCount * 96)
//                            self.existingBlockCount+=1
//                        }, completion: nil)
//                    }
//                }
//                self.recalcX()
//                self.resizeScrollView()
//            }
//            //
//        } else if (existingBlockCount < filteredBlockInfosIndex.count) {
//            //From end to start push apart blocks and then create new blocks
//            var addedBlockCount = filteredBlockInfosIndex.count - existingBlockCount
//            var slidingDelay = 0
//            existingBlockCount = 0
//
//            for index in stride(from: blockInfos.count-1, to: -1, by: -1) {
//                if filteredBlockInfosIndex.contains(index) && tripBlockViews[index] == nil {
//                    let blockview = HomeTripBlockView(info: blockInfos[index], num: filteredBlockInfosIndex.count-1-existingBlockCount, blockWidth: tripBlockWidth, indent: tripBlockIndent);
//                    addTapGesture(blockview, index)
//                    ContentView.addSubview(blockview)
//                    blockview.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * pow(-1.0, CGFloat(index)), y: 0)
//                    tripBlockViews[index] = blockview
//                    addedBlockCount-=1
//                    existingBlockCount+=1
//                } else if tripBlockViews[index] != nil {
//                    slidingDelay+=1
//                    existingBlockCount+=1
//                    UIView.animate(withDuration: 0.2, delay: Double(slidingDelay) * 0.05, options: [], animations: { self.tripBlockViews[index]!.frame.origin.y += CGFloat(96 * addedBlockCount)}, completion: nil)
//                }
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(slidingDelay) * 0.05) {
//                for index in stride(from: self.filteredBlockInfosIndex.count-1, to: -1, by: -1) {
//                    UIView.animate(withDuration: 0.2, delay: Double(self.filteredBlockInfosIndex.count-1 - index) * 0.05, options: [], animations: {
//                        self.tripBlockViews[self.filteredBlockInfosIndex[index]]?.transform = .identity
//                    }, completion: nil)
//                }
//                self.existingBlockCount = self.filteredBlockInfosIndex.count
//                self.recalcX()
//                self.resizeScrollView()
//            }
//
//        }
//    }
    
//    func recalcX() {
//        var index = 0
//        for view in tripBlockViews {
//            if let view = view {
//                UIView.animate(withDuration: 0.2, delay: CGFloat(index) * 0.1, options: [], animations: {
//                    view.frame.origin.x = (index % 2 == 0) ? 16 : (UIScreen.main.bounds.width - self.tripBlockWidth - self.tripBlockIndent)
//                    index+=1
//                }, completion: nil)
//            }
//        }
//    }
//    func resizeScrollView() {
//        self.scrollViewContainerHeightConstraint.constant = CGFloat(self.existingBlockCount * 96)
//        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { self.view.layoutIfNeeded()}, completion: nil)
//    }
//    func insertBlockInfo(info: TripInfoModel) {
//        searchBar.text = ""
//
//        blockInfos.insert(info, at: 0)
//        tripBlockViews.insert(nil, at: 0)
//
//        filteredBlockInfosIndex = []
//
//        var index = 0
//        for _ in blockInfos {
//            filteredBlockInfosIndex.append(index)
//            index+=1
//        }
//
//        updateTripBlockViews()
//    }
    
    private func updateTabBar() {
        guard let tabBarView else { return }
        
        for i in 0..<tabBarView.subviews[0].subviews.count {
            guard let button = tabBarView.subviews[0].subviews[i] as? UIButton else { continue }
            button.tintColor = UIColor.label
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func insert(_ trip: TripInfoModel, at index: UITableView.InsertType) {
//        let fitSearch = tripFitSearch(trip)
        
        switch index {
        case .start:
            trips.insert(trip, at: 0)
//            tableView?.insertRows(at: [IndexPath(index: 0)], with: .automatic)
        case .before(let index):
            trips.insert(trip, at: index - 1)
//            tableView?.insertRows(at: [IndexPath(index: index)], with: .automatic)
        case .after(let index):
            trips.insert(trip, at: index)
//            tableView?.insertRows(at: [IndexPath(index: index)], with: .automatic)
        case .end:
            trips.append(trip)
//            tableView?.insertRows(at: [IndexPath(index: filteredTrips.count - 1)], with: .automatic)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 50 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.tabBarView?.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.tabBarView?.alpha = 1
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeTripTableCellViewNibName, for: indexPath) as? HomeTripTableViewCell else {
            return UITableViewCell()
        }
        
        cell.update(with: filteredTrips[indexPath.item], index: indexPath.item)
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: HomeTripTableViewCellDelegate {
    func userDidSelect(_ cell: HomeTripTableViewCell) {
        guard let tripVC = self.storyboard?.instantiateViewController(withIdentifier: "tripDetailedController") as? TripDetailedViewController else { return }

        tripVC.info = cell.trip

        transitionToDetailedView.tripType = cell.trip?.type ?? .airplane
        transitionToDetailedView.startPoint.x = cell.localCenter().x
        transitionToDetailedView.startPoint.y = cell.center.y + (tableView?.frame.origin.y ?? 0) - (tableView?.contentOffset.y ?? 0)

        tripVC.transitioningDelegate = self
        tripVC.modalPresentationStyle = .custom

        present(tripVC, animated: true)
    }
}

extension HomeViewController: DBManagerObserverProtocol {
    func didLoginIn() {
        reloadList()
    }
    
    func didLogOut() {
        trips = []
    }
}

extension HomeViewController {
    private func tripFitSearch(_ trip: TripInfoModel, text: String) -> Bool {
        trip.placeFrom.lowercased().contains(text.lowercased()) ||
        trip.placeTo.lowercased().contains(text.lowercased()) ||
        String(describing: trip.price).lowercased().contains(text.lowercased()) ||
        text.isEmpty
    }
    
    private func tripFitSearch(_ trip: TripInfoModel) -> Bool {
        return tripFitSearch(trip, text: searchText)
    }
    
    private func filter(text: String) {
        filteredTrips = trips.filter {
            tripFitSearch($0, text: text)
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filter(text: searchText)
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
        if (segue.identifier == Constants.showListsSegueIdentifier) {
            if let toVC = segue.destination as? TripListViewController {
                toVC.tripType = sender as? TripType ?? .airplane
            }
        }
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let id = presented.restorationIdentifier
        switch id {
        case "tripDetailedController":
            transitionToDetailedView.transitionMode = .present
            return transitionToDetailedView
        default:
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let id = dismissed.restorationIdentifier
        switch id {
        case "tripDetailedController":
            transitionToDetailedView.transitionMode = .dismiss
            return transitionToDetailedView
        default:
            return nil
        }
    }
}
