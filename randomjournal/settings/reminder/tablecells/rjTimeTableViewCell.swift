//
//  rjTimeTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-21.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjTimeTableViewCell: UITableViewCell, rjCellConfigurable {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(viewModel: rjCellViewModel) {
        guard let viewModel = viewModel as? rjTimeCellViewModel else {
            fatalError("Expected rjTimeCellViewModel")
        }
        
        lblTitle.text = viewModel.title
    }
}
