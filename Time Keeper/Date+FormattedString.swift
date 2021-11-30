//
//  Date+FormattedString.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 5/7/21.
//

import Foundation

extension Date {

    var fullDateFormatted: String {
        DateFormatter.fullDateFormatter.string(from: self)
    }

    var timeFormatted: String {
        DateFormatter.timeFormatter.string(from: self)
    }

    var mediumTimeFormatted: String {
        DateFormatter.mediumTimeFormatter.string(from: self)
    }

    var fullDateTimeFormatted: String {
        DateFormatter.fullDateTimeFormatter.string(from: self)
    }
}
