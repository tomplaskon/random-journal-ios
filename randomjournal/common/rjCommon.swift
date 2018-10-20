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
        let beginningOfDay = self.getDateAtBeginningOfDay(now)
        return Int(beginningOfDay.timeIntervalSince1970)
    }
    
    static func getDateAtBeginningOfDay(_ date: Date) -> Date {
        let calendar = Calendar.current
        let beginningOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)
        return beginningOfDay!
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
    
    static func getRandomInt(from : Int, to : Int) -> Int {
        return Int(arc4random_uniform(UInt32(to-from)) + UInt32(from))
    }
}
