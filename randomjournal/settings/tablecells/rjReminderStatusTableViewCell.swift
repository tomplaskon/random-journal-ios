//
//  rjReminderStatusTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-30.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjReminderStatusTableViewCell: UITableViewCell, rjCellConfigurable {
    @IBOutlet var swRemindersEnabled: UISwitch!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(viewModel: rjCellViewModel) {
        guard let viewModel = viewModel as? rjReminderStatusCellViewModel else {
            fatalError("Expecting rjRemindersEnabledCellViewModel")
        }
        
        lblTitle.text = viewModel.title
        swRemindersEnabled.isOn = viewModel.remindersEnabled.value
    }

}
