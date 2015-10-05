//
//  StockTVCell.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/5/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class StockTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
