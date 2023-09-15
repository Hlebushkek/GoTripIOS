//
//  HomeTripTableViewCell.swift
//  GoTripIOS
//
//  Created by Hlib Sobolevskyi on 30.06.2023.
//

import UIKit

protocol HomeTripTableViewCellDelegate: AnyObject {
    func userDidSelect(_ cell: HomeTripTableViewCell)
}

class HomeTripTableViewCell: UITableViewCell {
    
    enum Constants {
        static let layerCornerRadius: CGFloat = 8
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.cornerRadius = Constants.layerCornerRadius
        return layer
    }()
    
    @IBOutlet private weak var gradientViewTrailingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var gradientViewLeadingConstraint: NSLayoutConstraint?
    
    @IBOutlet private weak var gradientView: UIView?
    @IBOutlet private weak var placeFromLabel: UILabel?
    @IBOutlet private weak var placeToLabel: UILabel?
    @IBOutlet private weak var priceLabel: UILabel?
    
    weak var delegate: HomeTripTableViewCellDelegate?
    
    var trip: TripInfoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer()
        setupGradientView()
    }
    
    deinit {
        gradientLayer.removeFromSuperlayer()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with trip: TripInfoModel, index: Int) {
        self.trip = trip
        
        updateGradient()
        updateLabels()
        updatePosition(for: index)
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
    
    private func setupGradientView() {
        gradientView?.layer.shadowColor = UIColor.black.cgColor
        gradientView?.layer.shadowRadius = 4
        gradientView?.layer.shadowOpacity = 0.3
        gradientView?.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        gradientView?.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = gradientView?.bounds ?? .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = gradientView?.bounds ?? .zero
        CATransaction.commit()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateGradient()
    }
    
    private func updateGradient() {
        guard let trip else { return }
        
        gradientLayer.colors = [
            trip.type.color().cgColor,
            trip.type.colorStrong().cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = gradientView?.bounds ?? .zero
    }
    
    private func updateLabels() {
        guard let trip else { return }
        
        placeFromLabel?.text = trip.placeFrom
        placeToLabel?.text = trip.placeTo
        priceLabel?.text = trip.price?.description
    }
    
    private func updatePosition(for index: Int) {
        gradientViewTrailingConstraint?.constant = index % 2 == 0 ? 4 : 16
        gradientViewLeadingConstraint?.constant = index % 2 == 0 ? 16 : 4
    }
    
    @objc private func tapAction(sender: Any?) {
        delegate?.userDidSelect(self)
    }
    
    func localCenter() -> CGPoint {
        return gradientView?.center ?? self.center
    }
}
