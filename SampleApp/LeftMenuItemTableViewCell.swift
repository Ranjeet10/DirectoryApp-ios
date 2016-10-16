//
//  LeftMenuItemTableViewCell.swift
//  sampleDirectoryApp
//
//  Created by Ranjeet Sah on 10/4/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class LeftMenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItemImageView: UIImageView!
    @IBOutlet weak var menuItemTitleLabel: UILabel!
    @IBOutlet weak var menuItemDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
