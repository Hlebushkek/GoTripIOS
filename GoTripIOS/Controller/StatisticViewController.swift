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
    
    let MaxStackHeight = 208
    
    var stackContainer: [[UIStackView]]!
    
    @IBOutlet var typeStacks: Array<UIStackView>!
    var typeStacksHeightConstraint: [NSLayoutConstraint] = []
    
    @IBOutlet var durationStacks: Array<UIStackView>!
    var durationStacksHeightConstraint: [NSLayoutConstraint] = []
    
    @IBOutlet var priceStacks: Array<UIStackView>!
    var priceStacksHeightConstraint: [NSLayoutConstraint] = []
    
    var stacksHeightConstraint: [[NSLayoutConstraint]]!
    
    //temp
    var counts: [[Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackContainer = [typeStacks, durationStacks, priceStacks]
        stacksHeightConstraint = [typeStacksHeightConstraint, durationStacksHeightConstraint, priceStacksHeightConstraint]
        
        counts.append(getCountByType())
        counts.append([3, 12, 4, 3, 1])
        counts.append([6, 7, 2, 11])
        
        roundCorners()
        getHeightConstraint()
        
        MenuSelection.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.0275 , y: 0.0);
        
        typeView.alpha = 0
        durationView.alpha = 0
        priceView.alpha = 0
    }
    func presentStatistic() {
        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
            self.typeView.alpha = 1}, completion: { _ in self.calcHeight(num: 0) })
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
        var typeCount = [0, 0, 0, 0]
        
        let blockInfo = LocalSavingSystem.LoadTripInfp(path: defaultsSavingKeys.tripInfoKey)!
        
        for info in blockInfo {
            typeCount[info.type.rawValue] += 1
        }   
        return typeCount
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
    
    func calcHeight(num: Int) {
        var curMax = 0
    
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
        if typeView.alpha == 1 {return}
        
        hideAll()
        UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
            self.MenuSelection.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.0275 , y: 0.0);
            self.typeView.alpha = 1}, completion: {_ in self.calcHeight(num: 0)})
    }
    @IBAction func durationButtonAction(_ sender: Any?) {
        if durationView.alpha == 1 {return}
        
        hideAll()
        UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
            self.MenuSelection.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.35 , y: 0.0);
            self.durationView.alpha = 1}, completion: {_ in self.calcHeight(num: 1)})
    }
    @IBAction func priceButtonAction(_ sender: Any?) {
        if priceView.alpha == 1 {return}
        
        hideAll()
        UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
            self.MenuSelection.frame.origin = CGPoint(x: UIScreen.main.bounds.width * 0.69 , y: 0.0);
            self.priceView.alpha = 1}, completion: {_ in self.calcHeight(num: 2)})
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
