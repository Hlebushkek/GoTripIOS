//
//  SettingViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 05.03.2022.
//

import UIKit

class SettingViewController: UIViewController {
    
    private let rowHeight: CGFloat = 32
    
    private let transperentView = UIView()
    private let tableView = UITableView()
    
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var currencySelectOutlet: UIButton!
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func currencySelectAction(_ sender: Any) {
        let frames = currencySelectOutlet.superview?.convert(currencySelectOutlet.frame, to: nil) ?? currencySelectOutlet.frame
        addTransperentView(frames)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset.left = 0
        
        let cellNib = UINib(nibName: "SelectionCell", bundle: .none)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        saveButtonOutlet.isEnabled = false
        
        currencySelectOutlet.setTitle(LocalSavingSystem.prefferedCurrency.rawValue, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = self.title
    }
    
    func addTransperentView(_ frames: CGRect) {
        transperentView.frame = UIScreen.main.bounds
        transperentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        transperentView.alpha = 0
        self.view.addSubview(transperentView)
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransperentView))
        transperentView.addGestureRecognizer(tapGesture)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.transperentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: self.rowHeight * CGFloat(CurrencyType.allCases.count))
        }, completion: nil)
    }
    @objc func removeTransperentView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.transperentView.alpha = 0
            self.tableView.frame = CGRect(origin: self.tableView.frame.origin, size: CGSize(width: self.tableView.frame.size.width, height: 0))
        }, completion: nil)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrencyType.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectionCell
        cell.title.text = CurrencyType.allCases[indexPath.row].rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = CurrencyType.allCases[indexPath.row]
        LocalSavingSystem.prefferedCurrency = type
        currencySelectOutlet.setTitle(type.rawValue, for: .normal)
        
        removeTransperentView()
    }
}
