//
//  CustomTabBarController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 11.10.2021.
//

import UIKit

final class CustomTabBar: UITabBar {
    private var tabBarWidth: CGFloat { self.bounds.width }
    private var tabBarHeight: CGFloat { self.bounds.height }
    private var centerWidth: CGFloat { self.bounds.width / 2 + 1 }
    private let circleRadius: CGFloat = 27
}
