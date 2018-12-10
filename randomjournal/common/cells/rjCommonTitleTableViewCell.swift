//
//  rjCommonTitleTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-02.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjCommonTitleTableViewCell: UITableViewCell, rjCellConfigurable {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setup(viewModel: rjCellViewModel) {
        guard let viewModel = viewModel as? rjCommonTitleCellViewModel else {
            fatalError("Expected rjCommonTitleCellViewModel")
        }
        
        lblTitle.text = viewModel.title
    }
}
