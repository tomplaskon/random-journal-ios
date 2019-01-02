//
//  rjCommon+UI.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-04.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

extension rjCommon {
    static func registerCommonTitleCell(tableView: UITableView) {
        let commonTitleNib = UINib.init(nibName: "rjCommonTitleTableViewCell", bundle: nil)
        tableView.register(commonTitleNib, forCellReuseIdentifier: commonTitleReuseId)
    }

    static func makeCommonTitleCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, title: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commonTitleReuseId, for: indexPath) as! rjCommonTitleTableViewCell
        
        cell.lblTitle.text = title
        
        return cell
    }
    
    static func registerCommonButtonCell(tableView: UITableView) {
        let commonTitleNib = UINib.init(nibName: "rjCommonButtonTableViewCell", bundle: nil)
        tableView.register(commonTitleNib, forCellReuseIdentifier: commonButtonReuseId)
    }
    
    static func makeButtonCell(tableView: UITableView, indexPath: IndexPath, btnText: String, target: Any, btnAction: Selector) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commonButtonReuseId, for: indexPath) as! rjCommonButtonTableViewCell
        cell.btnAction.setTitle(btnText, for: .normal)
        cell.btnAction.addTarget(target, action: btnAction, for: .touchUpInside)
        return cell;
    }
    
    static func registerCommonSpacerCell(tableView: UITableView) {
        let commonTitleNib = UINib.init(nibName: "rjCommonSpacerTableViewCell", bundle: nil)
        tableView.register(commonTitleNib, forCellReuseIdentifier: commonSpacerReuseId)
    }
    
    static func makeSpacerCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commonSpacerReuseId, for: indexPath) as! rjCommonSpacerTableViewCell
        return cell;
    }
}
