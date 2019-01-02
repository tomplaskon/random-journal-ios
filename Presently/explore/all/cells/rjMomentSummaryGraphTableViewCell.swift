//
//  rjMomentSummaryGraphTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-21.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentSummaryGraphTableViewCell: UITableViewCell {

    @IBOutlet var gvSummary: rjMomentSummaryGraphView!

    static let cellIdentifier = "summarygraph"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
