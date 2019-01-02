//
//  rjCommonButtonTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-04.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import Bond

class rjCommonButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var btnAction: UIButton!
    
    static let cellIdentifier = rjCommon.commonButtonReuseId
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setup(viewModel: rjCommonButtonCellViewModel) {
        btnAction.setTitle(viewModel.buttonText, for: .normal)
        
        _ = btnAction.reactive.tap.observeNext { [weak viewModel] in
            viewModel?.buttonAction?()
        }
    }
}
