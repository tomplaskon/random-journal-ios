//
//  rjTimeTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-21.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjTimeSelectTableViewCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var dpTime: UIDatePicker!
    @IBOutlet var dpHeightConstraint: NSLayoutConstraint!
    
    static let dpHeight: CGFloat = 177.5
    static let cellIdentifier = "timeselect"
    
    func setup(viewModel: rjTimeSelectCellViewModel) {
        lblTitle.text = viewModel.title
    }
}
