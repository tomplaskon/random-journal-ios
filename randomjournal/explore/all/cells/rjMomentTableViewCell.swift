//
//  rjMomentTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-07.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(viewModel: rjMomentViewModel) {
        lblDate.text = viewModel.when.contextual
        lblDetails.text = viewModel.details
    }
}
