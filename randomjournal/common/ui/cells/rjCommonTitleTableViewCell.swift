//
//  rjCommonTitleTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-02.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjCommonTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    static let cellIdentifier = rjCommon.commonTitleReuseId
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setup(viewModel: rjCommonTitleCellViewModel) {
        lblTitle.text = viewModel.title
    }
}
