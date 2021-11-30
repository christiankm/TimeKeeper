//
//  TimeEntry.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 5/7/21.
//

import Foundation
import SwiftUI

struct TimeEntry: Identifiable, Equatable {

    enum Tag: String, Codable {
        case work
        case `break`
    }

    var id: UUID = UUID()
    let startDate: Date
    let endDate: Date
    let tag: Tag?

    init(startDate: Date, endDate: Date, tag: Tag? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.tag = tag
    }

    static func ==(lhs: TimeEntry, rhs: TimeEntry) -> Bool {
        lhs.id == rhs.id
    }
}

extension TimeEntry: Codable {}
