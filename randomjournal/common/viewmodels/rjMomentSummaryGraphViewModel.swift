//
//  rjMomentSummaryGraphViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-12.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

struct rjMomentSummaryGraphViewModel: Equatable {
    let startDate: Date
    let endDate: Date
    var columns: [rjGraphColumn]
    
    var maxValue: Int?
    var minValue: Int?
    
    private let dateFormatter: DateFormatter
    
    struct rjGraphColumn: Equatable {
        var data: Int
        var ratio: Double
        var labelName: String
    }
    
    init(startDate: Date, endDate: Date, dateFormatter: DateFormatter = DateFormatter()) {
        self.startDate = startDate
        self.endDate = endDate
        self.dateFormatter = dateFormatter
        
        let numDays = rjCommon.getNumDaysBetween(from: startDate, to: endDate, calendar: dateFormatter.calendar)
        var columns = [rjGraphColumn]()
        for dayNum in 0...numDays {
            let date = rjCommon.add(days: dayNum, to: startDate)
            let labelName = date.with(format: "EEEEE", dateFormatter: dateFormatter) // one character day of the week
            let column = rjGraphColumn(data: 0, ratio: 0, labelName: labelName)
            columns.append(column)
        }
        self.columns = columns
    }
    
    mutating func add(moments: [rjMomentViewModel]) {
        
        // add the moments word counts to the column word counts
        for moment in moments {
            let dayNum = rjCommon.getNumDaysBetween(from: startDate, to: moment.when.date)
            if !(0..<columns.count).contains(dayNum) {
                // this moment is out of range
                continue
            }

            columns[dayNum].data += moment.details.wordCount
        }

        // calculate max and min values
        maxValue = dataValues.max()
        minValue = dataValues.min()
        
        // calculate the ratio for the columns
        for i in 0..<columns.count {
            if let maxValue = maxValue {
                columns[i].ratio = Double(columns[i].data) / Double(maxValue)
            }
        }
    }
    
    var columnNames: [String] {
        return columns.map { $0.labelName }
    }
    
    var dataValues: [Int] {
        return columns.map { $0.data }
    }
    
    var ratioValues: [Double] {
        return columns.map { $0.ratio }
    }
}
