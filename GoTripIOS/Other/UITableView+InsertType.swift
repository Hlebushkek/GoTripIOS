//
//  UITableView+InsertType.swift
//  GoTripIOS
//
//  Created by Hlib Sobolevskyi on 01.07.2023.
//

import UIKit

extension UITableView {
    enum InsertType {
        case start
        case before(Int)
        case after(Int)
        case end
    }
}
