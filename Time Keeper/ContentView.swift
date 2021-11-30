//
//  ContentView.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 5/7/21.
//

import SwiftUI
import FinanceKit

/// Daily pay rate
private let dailyRate = Money(0, in: Currency(code: .australianDollar))
private let secondsInWorkday = 27_600 // 7h 40m
private let secondsInWorkweek = 138_000 // 38h 20m

let timeInterval: TimeInterval = 300 // updates every 5 minutes to prevent huge CPU usage

struct ContentView: View {

    @EnvironmentObject private var store: Store

    @State private var runningTimer: TimeEntry?
    @State private var timer: Timer?

    @State private var isAddingPayout: Bool = false

    private var isCheckedIn: Bool {
        runningTimer != nil
    }

    private let calendar = Calendar.current
    private let currencyFormatter = CurrencyFormatter(currency: Currency(code: .australianDollar))

    private var startButton: some View {
        Button {
            runningTimer = TimeEntry(startDate: Date(), endDate: Date.distantFuture)
            store.add(runningTimer!)
            runningTimer = TimeEntry(startDate: runningTimer!.startDate, endDate: Date())
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { _ in
                runningTimer = TimeEntry(startDate: runningTimer!.startDate, endDate: Date())
            })
        } label: {
            Label("Start", systemImage: "play.circle.fill")
                .foregroundColor(.green)
        }
    }

    private var stopButton: some View {
        Button {
            timer?.invalidate()
            store.remove(store.allEntries.first!)
            let newEntry = TimeEntry(startDate: runningTimer!.startDate, endDate: Date())
            store.add(newEntry)
            runningTimer = nil
        } label: {
            Label("Stop", systemImage: "stop.circle.fill")
                .foregroundColor(.red)
        }
    }

    private var entriesThisWeekListItems: [TimeEntry] {
        let entriesThisWeek = loadEntriesThisWeek()
        return entriesThisWeek
    }

    private var allOtherEntriesListItems: [TimeEntry] {
        let entriesThisWeek = loadEntriesThisWeek()
        return Array(store.allEntries.dropFirst(entriesThisWeek.count))
    }

    private var worktimeToday: (dateComponents: DateComponents, timeInterval: TimeInterval) {
        let entriesToday = entriesThisWeekListItems.filter { calendar.isDateInToday($0.startDate) }

        var secondsWorked: TimeInterval = 0
        entriesToday.forEach { entry in
            secondsWorked += DateComponents(startDate: entry.startDate, endDate: entry.endDate).worktimeInterval
        }

        return (DateComponents(worktimeInterval: secondsWorked), secondsWorked)
    }

    private var worktimeTodayForegroundColor: Color {
        if worktimeToday.timeInterval >= Double(secondsInWorkday) {
            return Color.green
        } else {
            return Color.primary
        }
    }

    private var worktimeThisWeek: (dateComponents: DateComponents, timeInterval: TimeInterval) {
        var secondsWorked: TimeInterval = 0
        entriesThisWeekListItems.forEach { entry in
            secondsWorked += DateComponents(startDate: entry.startDate, endDate: entry.endDate).worktimeInterval
        }

        return (DateComponents(worktimeInterval: secondsWorked), secondsWorked)
    }

    private var worktimeThisWeekForegroundColor: Color {
        if worktimeThisWeek.timeInterval >= Double(secondsInWorkweek) {
            return Color.green
        } else {
            return Color.primary
        }
    }

    private var balanceFormattedString: String {
        let balance = TimeInterval(store.balance)
        let components = DateComponents(worktimeInterval: balance)

        return "\(components.payoutDaysFormatted ?? "--")"
    }

    private var balanceForegroundColor: Color {
        if balanceFormattedString.contains("-") {
            return Color.red
        } else {
            return Color.green
        }
    }

    private var earnedToday: Money {
        let dailyRate = dailyRate
        let secondRate = dailyRate.amount.doubleValue / Double(secondsInWorkday)

        return Money(amount: secondRate * worktimeToday.timeInterval)
    }

    var body: some View {
        VStack {
            // Workaround to get lists to update properly
            Text("Total entries: \(store.allEntries.count)")
                .hidden()

            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Text("\(Date().fullDateTimeFormatted)")
                }
            }
            .padding(.vertical)

            HStack {
                if isCheckedIn {
                    stopButton
                } else {
                    startButton
                }
            }

            Spacer()

            HStack {
                VStack(alignment: .leading) {
                    Text("Running timer: \(runningTimer?.startDate.mediumTimeFormatted ?? "--") - \(runningTimer?.endDate.mediumTimeFormatted ?? "--")")
                    Text("Balance: \(balanceFormattedString)")
                        .foregroundColor(balanceForegroundColor)
                    Text("Earned today: \(currencyFormatter.string(from: earnedToday) ?? "--")")
                    Text("Worked today: \(worktimeToday.dateComponents.workdayFormatted)")
                        .foregroundColor(worktimeTodayForegroundColor)
                    Text("Worked this week: \(worktimeThisWeek.dateComponents.workdayFormatted)")
                }
                Spacer()
            }

            Spacer()

            Group {
                Text("Entries this week (\(entriesThisWeekListItems.count))")
                // TODO: Use Table
                List {
                    ForEach(entriesThisWeekListItems) { entry in
                        EntryRowView(entry: entry, runningTimer: $runningTimer, timer: $timer)
                    }
                }
            }

            Group {
                Text("All other entries (\(allOtherEntriesListItems.count))")
                List {
                    ForEach(allOtherEntriesListItems) { entry in
                        EntryRowView(entry: entry, runningTimer: $runningTimer, timer: $timer)
                    }
                }
            }

            Group {
                Text("Payouts (\(store.allPayouts.count))")
                List {
                    ForEach(store.allPayouts) { payout in
                        PayoutRowView(payout: payout)
                    }
                }
            }

            Button {
                isAddingPayout = true
            } label: {
                Label("New Payout", systemImage: "calendar.badge.clock")
            }
            .sheet(isPresented: $isAddingPayout, onDismiss: nil) {
                AddPayoutView()
                    .environmentObject(store)
            }
        }
        .padding()
        .onAppear {
            loadEntries()
            loadPayouts()
            continueActiveTimer()
        }
    }

    private func continueActiveTimer() {
        guard let first = store.allEntries.first,
              first.endDate == Date.distantFuture else { return }

        runningTimer = TimeEntry(startDate: first.startDate, endDate: Date())
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { _ in
            runningTimer = TimeEntry(startDate: runningTimer!.startDate, endDate: Date())
        })
    }

    private func loadEntries() {
        _ = try! store.loadTimeEntries()
    }

    private func loadPayouts() {
        _ = try! store.loadPayouts()
    }

    private func loadEntriesThisWeek() -> [TimeEntry] {
        store.allEntries.filter { calendar.isDate($0.startDate, equalTo: Date(), toGranularity: .weekOfYear) }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store())
    }
}
