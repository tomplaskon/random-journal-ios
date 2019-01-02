//
//  rjMomentViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-10.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

struct rjMomentViewModel: Equatable {
    struct rjMomentWhenDateViewModel: Equatable {
        let date: Date
        fileprivate let referenceDate: Date
        
        init(date: Date, referenceDate: Date = Date()) {
            self.date = date
            self.referenceDate = referenceDate
        }
        
        var long: String {
            return rjCommon.getReadableDateLong(date)
        }
        
        var intValue: Int {
            return date.intValue
        }
        
        var contextual: String {
            return self.getContextualDate(relativeTo: referenceDate)
        }
        
        func getContextualDate(relativeTo referenceDate: Date = Date()) -> String {
            let daysSinceReferenceDate = date.numDays(since: referenceDate)
            
            let isToday = daysSinceReferenceDate == 0
            if isToday {
                return date.with(format: "'Today' @ h:mm a") // Today @ 4:01 PM
            }
            
            let isYesterday = daysSinceReferenceDate == 1
            if isYesterday {
                return date.with(format: "'Yesterday' @ h:mm a") // Yesterday @ 4:01 PM
            }
            
            let withinAWeek = (1...7).contains(daysSinceReferenceDate)
            if withinAWeek {
                return date.with(format: "EEEE @ h:mm a") // Thursday @ 1:12 PM
            }

            let inSameYear = date.year == referenceDate.year
            if inSameYear {
                return date.with(format: "E, MMMM d @ h:mm a") // Mon, December 2 @ 11:21 AM
            }
            
            return date.with(format: "E, MMM d, YYYY @ ha") // Tues, Feb 7, 2016 @ 1PM
        }
        
        static func == (lhs: rjMomentWhenDateViewModel, rhs: rjMomentWhenDateViewModel) -> Bool {
            return lhs.date == rhs.date
        }
    }
    
    var id: String
    var when: rjMomentWhenDateViewModel
    var details: String
    
    init(id: String, when: Date, details: String, referenceDate: Date = Date()) {
        self.id = id
        self.when = rjMomentWhenDateViewModel(date: when, referenceDate: referenceDate)
        self.details = details
    }
    
    init(_ entityModel: rjMomentEntityModel, referenceDate: Date = Date()) {
        self.id = entityModel.id
        self.when = rjMomentWhenDateViewModel(date: entityModel.when, referenceDate: referenceDate)
        self.details = entityModel.details
    }
    
    var entityModel : rjMomentEntityModel {
        return rjMomentEntityModel(
            id: id,
            when: when.date,
            details: details
        )
    }
}
