//
//  rjDateTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjDateSelectTableViewCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!    
    @IBOutlet var dpHeightConstraint: NSLayoutConstraint!
    @IBOutlet var dpDate: UIDatePicker!
    
    static let dpHeight: CGFloat = 178
    static let cellIdentifier = "dateselect"

    func setup(viewModel: rjDateSelectCellViewModel) {
        lblTitle.text = viewModel.title
    }
}
