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
    
    var maxValue : Int?
    var minValue : Int?
    
    struct rjGraphColumn: Equatable {
        var data: Int
        var ratio: Double
        var labelName: String
    }
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        
        let numDays = rjCommon.getNumDaysBetween(from: startDate, to: endDate)
        var columns = [rjGraphColumn]()
        for dayNum in 0...numDays {
            let date = rjCommon.add(days: dayNum, to: startDate)
            let labelName = rjMomentSummaryGraphViewModel.getLabelName(for: date)
            let column = rjGraphColumn(data: 0, ratio: 0, labelName: labelName)
            columns.append(column)
        }
        self.columns = columns
    }
    
    private static func getLabelName(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE" // one character day of the week
        return dateFormatter.string(from: date)
    }
    
    mutating func add(moments: [rjMomentViewModel]) {
        
        // add the moments word counts to the column word counts
        for moment in moments {
            let numWords = moment.details.wordCount
            
            // keep the max and min counts up to date
            maxValue = numWords > (maxValue ?? numWords) ? numWords : (maxValue ?? numWords)
            minValue = numWords < (minValue ?? numWords) ? numWords : (minValue ?? numWords)
            
            let dayNum = rjCommon.getNumDaysBetween(from: startDate, to: moment.when)
            if !(0..<columns.count).contains(dayNum) {
                // this moment is out of range
                continue
            }
            
            columns[dayNum].data += numWords
        }
        
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