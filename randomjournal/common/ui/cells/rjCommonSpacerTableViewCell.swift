//
//  rjCommonSpacerTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjCommonSpacerTableViewCell: UITableViewCell {

    static let cellIdentifier = rjCommon.commonSpacerReuseId
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
