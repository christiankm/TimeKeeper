//
//  DateComponents+TimeIntervalTests.swift
//  Time KeeperTests
//
//  Created by Christian Mitteldorf on 7/7/21.
//

import Time_Keeper
import XCTest

class DateComponents_TimeIntervalTests: XCTestCase {

    func testDateComponentsFromTimeIntervalSeconds() throws {
        let timeInterval: TimeInterval = 23
        let sut = DateComponents(worktimeInterval: timeInterval)

        XCTAssertEqual(sut.day, 0)
        XCTAssertEqual(sut.hour, 0)
        XCTAssertEqual(sut.minute, 0)
        XCTAssertEqual(sut.second, 23)
    }

    func testDateComponentsFromTimeIntervalSecondsMinutes() throws {
        let timeInterval: TimeInterval = 3_203
        let sut = DateComponents(worktimeInterval: timeInterval)

        XCTAssertEqual(sut.day, 0)
        XCTAssertEqual(sut.hour, 0)
        XCTAssertEqual(sut.minute, 53)
        XCTAssertEqual(sut.second, 23)
    }

    func testDateComponentsFromTimeIntervalSecondsMinutesHours() throws {
        let timeInterval: TimeInterval = 26_412
        let sut = DateComponents(worktimeInterval: timeInterval)

        XCTAssertEqual(sut.day, 0)
        XCTAssertEqual(sut.hour, 7)
        XCTAssertEqual(sut.minute, 20)
        XCTAssertEqual(sut.second, 12)
    }

    func testDateComponentsFromTimeIntervalSecondsMinutesHoursDays() throws {
        let timeInterval: TimeInterval = 92_603
        let sut = DateComponents(worktimeInterval: timeInterval)

        XCTAssertEqual(sut.day, 3)
        XCTAssertEqual(sut.hour, 2)
        XCTAssertEqual(sut.minute, 43)
        XCTAssertEqual(sut.second, 23)
    }
}
