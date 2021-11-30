//
//  Store.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 5/7/21.
//

import SwiftUI

/// Balance of worktime measured in days.
typealias Balance = Double

final class Store: ObservableObject {

    @Published var allEntries: [TimeEntry] = []
    @Published var allPayouts: [Payout] = []
    @Published var balance: Balance = 0.0

    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    init() {
        _ = try! loadTimeEntries()
        _ = try! loadPayouts()
        calculateBalance()
    }

    // MARK: - Time Entries

    func loadTimeEntries() throws -> [TimeEntry] {
        let filePath = documentsDirectory.appendingPathComponent("TimeKeeper.json")

        if !fileManager.fileExists(atPath: filePath.path) {
            try "[]".data(using: .utf8)!.write(to: filePath)
            print("New empty file created at \(filePath)")
        }

        guard fileManager.isReadableFile(atPath: filePath.path) else { fatalError() }

        let contents = try String(contentsOfFile: filePath.path)
        let entries = try decoder.decode([TimeEntry].self, from: contents.data(using: .utf8) ?? Data())

        print("Data read from \(filePath)")

        let sortedEntries = entries.sorted { $0.startDate.isAfter($1.startDate) }

        allEntries = sortedEntries

        return sortedEntries
    }

    func add(_ entry: TimeEntry) {
        var entries = allEntries
        entries.append(entry)
        allEntries = entries.sorted { $0.startDate.isAfter($1.startDate) }
        try! saveEntriesToFile(allEntries)
        calculateBalance()
    }

    func edit(_ entry: TimeEntry, newStartDate: Date, newEndDate: Date) {
        remove(entry)

        let newEntry = TimeEntry(startDate: newStartDate, endDate: newEndDate, tag: entry.tag)
        add(newEntry)
    }

    func remove(_ entry: TimeEntry) {
        print("Removing \(entry)")
        print("Had \(allEntries.count) entries")
        var entries = allEntries
        entries.removeAll(where: { $0.id == entry.id })
        allEntries = entries
        print("Now \(allEntries.count) entries after removal")
        try! saveEntriesToFile(entries)
        calculateBalance()
    }

    private func saveEntriesToFile(_ entries: [TimeEntry]) throws {
        let filePath = documentsDirectory.appendingPathComponent("TimeKeeper.json")

        guard fileManager.isWritableFile(atPath: filePath.path) else { fatalError() }

        let sortedEntries = entries.sorted { $0.startDate.isAfter($1.startDate) }
        let data = try encoder.encode(sortedEntries)

        try data.write(to: filePath)

        print("Data written to \(filePath.path)")
    }

    // MARK: - Payouts

    func loadPayouts() throws -> [Payout] {
        let filePath = documentsDirectory.appendingPathComponent("TimeKeeper_Payouts.json")

        if !fileManager.fileExists(atPath: filePath.path) {
            try "[]".data(using: .utf8)!.write(to: filePath)
            print("New empty file created at \(filePath)")
        }

        guard fileManager.isReadableFile(atPath: filePath.path) else { fatalError() }

        let contents = try String(contentsOfFile: filePath.path)
        let entries = try decoder.decode([Payout].self, from: contents.data(using: .utf8) ?? Data())

        print("Data read from \(filePath)")

        let sortedEntries = entries.sorted { $0.date.isAfter($1.date) }

        allPayouts = sortedEntries

        return sortedEntries
    }

    func add(_ payout: Payout) {
        var payouts = allPayouts
        payouts.append(payout)
        allPayouts = payouts.sorted { $0.date.isAfter($1.date) }
        try! savePayoutsToFile(allPayouts)
        calculateBalance()
    }

    func remove(_ payout: Payout) {
        print("Removing \(payout)")
        print("Had \(allPayouts.count) payouts")
        var payouts = allPayouts
        payouts.removeAll(where: { $0.id == payout.id })
        allPayouts = payouts
        print("Now \(allPayouts.count) payouts after removal")
        try! savePayoutsToFile(payouts)
        calculateBalance()
    }

    private func savePayoutsToFile(_ entries: [Payout]) throws {
        let filePath = documentsDirectory.appendingPathComponent("TimeKeeper_Payouts.json")

        guard fileManager.isWritableFile(atPath: filePath.path) else { fatalError() }

        let sortedEntries = entries.sorted { $0.date.isAfter($1.date) }
        let data = try encoder.encode(sortedEntries)

        try data.write(to: filePath)

        print("Data written to \(filePath.path)")
    }

    // MARK: - Balance

    func calculateBalance() {
        let timeEntries = allEntries
        let payouts = allPayouts

        var balance: Balance = 0
        timeEntries.forEach { entry in
            balance += DateComponents(startDate: entry.startDate, endDate: entry.endDate).worktimeInterval
        }
        payouts.forEach { payout in
            balance -= payout.worktimeInterval
        }

        self.balance = balance
    }
}
