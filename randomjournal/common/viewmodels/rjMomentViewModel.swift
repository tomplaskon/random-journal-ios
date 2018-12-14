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
        
        var long: String {
            return rjCommon.getReadableDateLong(date)
        }
        
        var intValue: Int {
            return date.intValue
        }
        
        var contextual: String {
            return self.getContextualDate()
        }
        
        func getContextualDate(relativeTo referenceDate: Date = Date()) -> String {
            let daysSinceReferenceDate = date.numDays(since: referenceDate)
            
            let isToday = daysSinceReferenceDate == 0
            if (isToday) {
                return date.with(format: "'Today' @ h:mm a") // Today @ 4:01 PM
            }
            
            let withinAWeek = (1...7).contains(daysSinceReferenceDate)
            if (withinAWeek) {
                return date.with(format: "EEEE @ h:mm a") // Thursday @ 1:12 PM
            }

            let inSameYear = date.year == referenceDate.year
            if (inSameYear) {
                return date.with(format: "E, MMMM d @ h:mm a") // Mon, December 2 @ 11:21 AM
            }
            
            return date.with(format: "E, MMM d, YYYY @ ha") // Tues, Feb 7, 2016 @ 1PM
        }
    }
    
    var id: String
    var when: rjMomentWhenDateViewModel
    var details: String
    
    init(id: String, when: Date, details: String) {
        self.id = id
        self.when = rjMomentWhenDateViewModel(date: when)
        self.details = details
    }
    
    init(_ moment: rjMoment) {
        self.id = moment.momentId
        self.when = rjMomentWhenDateViewModel(date:
            Date(timeIntervalSince1970: TimeInterval(moment.when))
        )
        self.details = moment.details
    }
}
