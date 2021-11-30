//
//  DateFormatter+Format.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 5/7/21.
//

import Foundation

extension DateFormatter {

    static let timeFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static let mediumTimeFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()

    static let fullDateTimeFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        return formatter
    }()

    static let fullDateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
}
