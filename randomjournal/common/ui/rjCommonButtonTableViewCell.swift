//
//  rjCommonButtonTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-04.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjCommonButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var btnAction: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
