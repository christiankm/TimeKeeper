//
//  DateComponents+TimeInterval.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 7/7/21.
//

import Foundation

public extension DateComponents {

    static let secondsInMinute: TimeInterval = 60
    static let secondsInHour: TimeInterval = 3600
    static let secondsInWorkday: TimeInterval = 27_600 // 7h 40m
    static let secondsInWorkweek: TimeInterval = 138_000 // 38h 20m

    /// Creates an instance of `DateComponents` with the duration in *working time* from a time interval.
    ///
    /// Working time in this context means that one day is equal to a standard working day of 7 hours 40 minutes.
    /// - Parameter worktimeInterval: Date component with the working time duration.
    init(worktimeInterval: TimeInterval) {
        var remainder: TimeInterval = worktimeInterval
        let days: Int = Int(remainder / Self.secondsInWorkday)
        remainder -= Double(days) * Self.secondsInWorkday
        let hours: Int = Int(remainder / Self.secondsInHour)
        remainder -= Double(hours) * Self.secondsInHour
        let minutes: Int = Int(remainder / Self.secondsInMinute)
        remainder -= Double(minutes) * Self.secondsInMinute
        let seconds: Int = Int(remainder)

        self = DateComponents(day: days, hour: hours, minute: minutes, second: seconds)
    }

    init(startDate: Date, endDate: Date) {
        let end = endDate == Date.distantFuture ? Date() : endDate
        self = Calendar.current.dateComponents(
            [.day, .hour, .minute, .second],
            from: startDate,
            to: end
        )
    }

    var worktimeInterval: TimeInterval {
        var timeInterval: TimeInterval = 0
        timeInterval += TimeInterval(day ?? 0) * Self.secondsInWorkday
        timeInterval += TimeInterval(hour ?? 0) * 60 * 60
        timeInterval += TimeInterval(minute ?? 0) * 60
        timeInterval += TimeInterval(second ?? 0)
        return timeInterval
    }
}
