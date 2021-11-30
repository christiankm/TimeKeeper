//
//  Payout.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 6/7/21.
//

import Foundation

struct Payout: Identifiable, Codable {

    enum Days: Double, Codable, CaseIterable, Identifiable {
        typealias RawValue = Double

        case quarter = 0.25
        case half = 0.50
        case threeQuarters = 0.75
        case full = 1

        var id: RawValue {
            rawValue
        }
    }

    var id = UUID()
    let date: Date
    let days: Days

    var worktimeInterval: TimeInterval {
        days.rawValue * DateComponents.secondsInWorkday
    }
}
