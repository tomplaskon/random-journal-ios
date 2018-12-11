//
//  rjEditDetailsTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjEditDetailsTableViewCell: UITableViewCell {

    @IBOutlet var txtDetails: UITextView!
    
    static let cellIdentifier = "details"
    
    func setup(viewModel: rjEditDetailsCellViewModel) {
        txtDetails.text = viewModel.details.value
    }
}
