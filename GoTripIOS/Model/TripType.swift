//
//  TripType.swift
//  GoTripIOS
//
//  Created by Hlib Sobolevskyi on 2023-09-15.
//

import UIKit

public enum TripType: Int, Codable, CaseIterable {
    case airplane
    case train
    case bus
    case car
    
    func title() -> String {
        switch self {
        case .airplane:
            return "Airplane"
        case .train:
            return "Train"
        case .bus:
            return "Bus"
        case .car:
            return "Car"
        }
    }
    
    func imageName() -> String {
        switch self {
        case .airplane:
            return "airplane"
        case .train:
            return "train.side.front.car"
        case .bus:
            return "bus.fill"
        case .car:
            return "car.fill"
        }
    }
    
    func color() -> UIColor {
        return UIColor(named: title()) ?? .black
    }
    
    func colorStrong() -> UIColor {
        return UIColor(named: title() + "Strong") ?? .black
    }
    
    func image(for appearance: UIUserInterfaceStyle = .unspecified) -> UIImage {
        let img = UIImage(systemName: imageName()) ?? .remove
        if let color = TripType.tintColor(for: appearance) {
            return img.withTintColor(color)
        } else {
            return img
        }
    }
    
    static func tintColor(for appearance: UIUserInterfaceStyle) -> UIColor? {
        switch appearance {
        case .unspecified:
            return nil
        case .light:
            return .black
        case .dark:
            return .white
        @unknown default:
            fatalError("Unsupported appearance")
        }
    }
}
