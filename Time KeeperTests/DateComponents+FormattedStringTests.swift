//
//  DateComponents+FormattedStringTests.swift
//  Time KeeperTests
//
//  Created by Christian Mitteldorf on 7/7/21.
//

@testable import Time_Keeper
import XCTest

class DateComponents_FormattedStringTests: XCTestCase {

    func testPayoutDaysFormatted() throws {
        var sut = DateComponents(worktimeInterval: 27_600)
        XCTAssertEqual(sut.payoutDaysFormatted, "1d, 0h 0min.")

        sut = DateComponents(worktimeInterval: 19_380)
        XCTAssertEqual(sut.payoutDaysFormatted, "0.5d, 1h 33min.")

        sut = DateComponents(worktimeInterval: 76_620)
        XCTAssertEqual(sut.payoutDaysFormatted, "2.75d, 0h 11min.")

        sut = DateComponents(worktimeInterval: 9_300)
        XCTAssertEqual(sut.payoutDaysFormatted, "0.25d, 0h 40min.")
    }
}
