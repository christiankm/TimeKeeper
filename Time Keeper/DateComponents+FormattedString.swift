//
//  DateComponents+FormattedString.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 5/7/21.
//

import Foundation

extension DateComponents {

    var timeFormatted: String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self)
    }

    var workdayFormatted: String {
        "\(self.day ?? 0)d \(self.hour ?? 0)h \(self.minute ?? 0)m \(self.second ?? 0)s"
    }

    /// Returns a string formatted as payout days e.g. 1.25d, 1h 38min
    var payoutDaysFormatted: String? {
        let components = self
        let timeInterval = components.worktimeInterval
        let workdays = timeInterval / Self.secondsInWorkday

        var remainder = workdays.truncatingRemainder(dividingBy: 1)
        let workdayFractionString: String
        switch remainder {
        case 0.25..<0.50:
            workdayFractionString = ".25"
            remainder -= 0.25
        case 0.50..<0.75:
            workdayFractionString = ".5"
            remainder -= 0.50
        case 0.75..<1.00:
            workdayFractionString = ".75"
            remainder -= 0.75
        default:
            workdayFractionString = ""
        }

        let formattedWorkdays = "\(Int(workdays))\(workdayFractionString)d"

        let remainderComponents = DateComponents(worktimeInterval: remainder * Self.secondsInWorkday)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        let formattedHourMinute = formatter.string(from: remainderComponents)

        return "\(formattedWorkdays), \(formattedHourMinute ?? "")"
    }
}
