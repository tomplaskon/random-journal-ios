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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setup(viewModel: rjCellViewModel) {
        guard let viewModel = viewModel as? rjCommonTitleCellViewModel else {
            fatalError("Expected rjCommonTitleCellViewModel")
        }
        
        lblTitle.text = viewModel.title
    }
}