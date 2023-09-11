//
//  StatisticViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 01.11.2021.
//

import UIKit

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var durationButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var MenuSelection: UIStackView!
    
    private let MaxStackHeight = 208
    private var currentlySelectedWindow = ActiveWindow.None
    
    var stackContainer: [[UIStackView]]!
    
    @IBOutlet var typeStacks: Array<UIStackView>!
    var typeStacksHeightConstraint: [NSLayoutConstraint] = []
    
    @IBOutlet var durationStacks: Array<UIStackView>!
    var durationStacksHeightConstraint: [NSLayoutConstraint] = []
    
    @IBOutlet var priceStacks: Array<UIStackView>!
    var priceStacksHeightConstraint: [NSLayoutConstraint] = []
    
    var stacksHeightConstraint: [[NSLayoutConstraint]]!
    
    let dbManager = DBManager.shared
    
    //temp
    var counts: [[Int]] = []
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackContainer = [typeStacks, durationStacks, priceStacks]
        stacksHeightConstraint = [typeStacksHeightConstraint, durationStacksHeightConstraint, priceStacksHeightConstraint]
        
        recalcHeight()
        roundCorners()
        getHeightConstraint()
        
        MenuSelection.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.0275 , y: 0.0);
        
        typeView.alpha = 0
        durationView.alpha = 0
        priceView.alpha = 0
        
        typeButtonAction(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = self.title
        
        if currentlySelectedWindow != .None {
            recalcHeight()
            calcHeight()
        }
    }
    
    func roundCorners() {
        for horizontalStack in stackContainer {
            for stack in horizontalStack {
                stack.subviews[0].subviews[0].layer.cornerRadius = 5
                stack.subviews[0].subviews[0].layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                stack.subviews[1].layer.cornerRadius = 5
                stack.subviews[1].layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
        }
    }
    func getCountByType() -> [Int] {
        return dbManager.getTripCountByTrip()
    }
    func recalcHeight() {
        counts.removeAll()
        counts.append(getCountByType())
        counts.append([3, 12, 4, 3, 1])
        counts.append([6, 7, 2, 11])
    }
    func getHeightConstraint() {
        for i in 0...stacksHeightConstraint.count - 1 {
            for j in 0...stackContainer[i].count - 1 {
                let block = stackContainer[i][j].subviews[0].subviews[0]
                let constraint:NSLayoutConstraint = NSLayoutConstraint(item: block, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 16.0)
                constraint.isActive = true
                stacksHeightConstraint[i].append(constraint)
            }
        }
    }
    
    func calcHeight() {
        let num = currentlySelectedWindow.rawValue
        var curMax = 1
    
        for i in 0...stackContainer[num].count-1 {
            if counts[num][i] > curMax {
                curMax = counts[num][i]
            }
        }
        let k = CGFloat(MaxStackHeight) / CGFloat(curMax)
        
        for i in 0...stackContainer[num].count-1 {
            stacksHeightConstraint[num][i].constant = CGFloat(counts[num][i]) * k
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.stackContainer[num][i].subviews[0].layoutIfNeeded()
            })
            
            let label = stackContainer[num][i].subviews[0].subviews[1] as! UILabel
            label.text = String(self.counts[num][i])
            UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseIn, animations: {
                label.alpha = 1
            })
        }
    }
    func revertCalcHeight() {
        for i in 0...stackContainer.count - 1 {
            for j in 0...stackContainer[i].count - 1 {
                
                let label = stackContainer[i][j].subviews[0].subviews[1] as! UILabel
                label.text = String(self.counts[i][j])
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    label.alpha = 0
                })
                
                stacksHeightConstraint[i][j].constant = 16
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    self.stackContainer[i][j].subviews[0].layoutIfNeeded()
                })
            }
        }
    }
    
    func hideAll() {
        revertCalcHeight()
        UIView.animate(withDuration: 0.25, delay: 0.25, animations: {
            self.typeView.alpha = 0
            self.durationView.alpha = 0
            self.priceView.alpha = 0
        })
    }
    @IBAction func typeButtonAction(_ sender: Any?) {
        if currentlySelectedWindow == .TripType {return}
        
        hideAll()
        UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
            self.MenuSelection.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.0275 , y: 0.0);
            self.typeView.alpha = 1}, completion: {_ in
                self.currentlySelectedWindow = .TripType
                self.calcHeight()
            })
    }
    @IBAction func durationButtonAction(_ sender: Any?) {
        if currentlySelectedWindow == .Duration {return}
        
        hideAll()
        UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
            self.MenuSelection.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.35 , y: 0.0);
            self.durationView.alpha = 1}, completion: {_ in
                self.currentlySelectedWindow = .Duration
                self.calcHeight()
            })
    }
    @IBAction func priceButtonAction(_ sender: Any?) {
        if currentlySelectedWindow == .Price {return}
        
        hideAll()
        UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
            self.MenuSelection.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.69 , y: 0.0);
            self.priceView.alpha = 1}, completion: {_ in
                self.currentlySelectedWindow = .Price
                self.calcHeight()
            })
    }
}

fileprivate enum ActiveWindow: Int {
    case TripType
    case Duration
    case Price
    case None
}
