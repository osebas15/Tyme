//
//  TimeRange.swift
//  Thyme
//
//  Created by Sebastian Aguirre on 4/12/24.
//
// when an activity is active it will create a timerange and once its made inactive it will add an end date

import Foundation

struct TimeRange: Codable {
    var start: Date
    var end: Date?
    
    init(start: Date, end: Date?) {
        self.start = start
        self.end = end
    }
}

extension TimeRange {
    mutating func endTimeRange() {
        self.end = Date()
    }
    
    func totalTime() -> TimeInterval {
        // If end date is not nil, calculate the difference between start and end
        // Otherwise, calculate the difference between start and the current time
        guard let endTime = self.end else {
            return Date().timeIntervalSince(self.start)
        }
        return endTime.timeIntervalSince(self.start)
    }
}
