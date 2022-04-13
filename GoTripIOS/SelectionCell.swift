//
//  SelectionCell.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 06.03.2022.
//

import UIKit

class SelectionCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
