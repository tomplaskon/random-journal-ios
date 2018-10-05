//
//  rjCommon.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjCommon {
    static func unixTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    static func unixTimestampMilliseconds() -> TimeInterval {
        return Date().timeIntervalSince1970
    }

    static func unixTimestampAtBeginningOfToday() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let beginningOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)
        return Int(beginningOfDay!.timeIntervalSince1970)
    }
    
    static let commonTitleReuseId = "commontitle"
    static func registerCommonTitleCell(tableView: UITableView) {
        let commonTitleNib = UINib.init(nibName: "rjCommonTitleTableViewCell", bundle: nil)
        tableView.register(commonTitleNib, forCellReuseIdentifier: commonTitleReuseId)
    }
    
    static func makeCommonTitleCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, title: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commonTitleReuseId, for: indexPath) as! rjCommonTitleTableViewCell
        
        cell.lblTitle.text = title
        
        return cell
    }
    
    
    static let commonButtonReuseId = "commonbutton"
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
}

extension String {
    func escapeString() -> String {
        var newString = self.replacingOccurrences(of: "\"", with: "\"\"")

        if newString.contains(",") || newString.contains("\n") {
            newString = String(format: "\"%@\"", newString)
        }
        
        return newString
    }
}
