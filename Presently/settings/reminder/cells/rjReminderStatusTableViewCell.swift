//
//  rjReminderStatusTableViewCell.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-30.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjReminderStatusTableViewCell: UITableViewCell {
    @IBOutlet var swRemindersEnabled: UISwitch!
    @IBOutlet var lblTitle: UILabel!
    
    static let cellIdentifier = "reminderstatus"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setup(viewModel: rjReminderStatusCellViewModel) {
        lblTitle.text = viewModel.title
        swRemindersEnabled.isOn = viewModel.remindersEnabled.value
    }

}
