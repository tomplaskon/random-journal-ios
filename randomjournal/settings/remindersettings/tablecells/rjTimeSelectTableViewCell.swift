//
//  rjTimeSelectTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-21.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjTimeSelectTableViewCell: UITableViewCell {

    @IBOutlet var dpTime: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
