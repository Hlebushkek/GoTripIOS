//
//  TripInfoGestureRecognizer.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 24.11.2021.
//

import UIKit

class TripInfoGestureRecognizer: UITapGestureRecognizer {
    var info: TripInfo = TripInfo.empty()
    var centerPoint: CGPoint = CGPoint.zero
}
