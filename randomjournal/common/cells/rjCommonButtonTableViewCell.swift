//
//  rjCommonButtonTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-04.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import Bond

class rjCommonButtonTableViewCell: UITableViewCell, rjCellConfigurable {
    @IBOutlet weak var btnAction: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(viewModel: rjCellViewModel) {
        guard let viewModel = viewModel as? rjCommonButtonCellViewModel else {
            fatalError("Expected rjCommonButtonCellViewModel")
        }
        
        btnAction.setTitle(viewModel.buttonText, for: .normal)
        
        _ = btnAction.reactive.tap.observeNext { [weak viewModel] in
            viewModel?.buttonAction?()
        }
    }
}
