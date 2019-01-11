//
//  rjNextReminderView.swift
//  Presently
//
//  Created by Tom Plaskon on 2019-01-08.
//  Copyright © 2019 Tom Plaskon. All rights reserved.
//

import UIKit
import Bond

class rjNextReminderView: UIView {
    let nextReminderAt = Observable<String?>(nil)
    let lblNextReminder = rjNextReminderView.makeNextReminderLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private static func makeNextReminderLabel() -> UILabel {
        let label = UILabel()
    
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }
    
    private func setupView() {
        nextReminderAt.bind(to: lblNextReminder)
        addSubview(lblNextReminder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            lblNextReminder.topAnchor.constraint(equalTo: topAnchor, constant: regularSpace),
            lblNextReminder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: regularSpace * -1),
            lblNextReminder.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: regularSpace * -1),
            lblNextReminder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: regularSpace),
        ])
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
