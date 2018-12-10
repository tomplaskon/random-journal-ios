//
//  rjEditDetailsTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjEditDetailsTableViewCell: UITableViewCell, rjCellConfigurable {

    @IBOutlet var txtDetails: UITextView!
    
    func setup(viewModel: rjCellViewModel) {
        guard let viewModel = viewModel as? rjEditDetailsViewModel else {
            fatalError("Expecting rjEditDetailsViewModel")
        }
        
        txtDetails.text = viewModel.details.value
    }
}
