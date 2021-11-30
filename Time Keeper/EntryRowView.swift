//
//  EntryRowView.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 12/7/21.
//

import SwiftUI

struct EntryRowView: View {

    @EnvironmentObject private var store: Store

    let entry: TimeEntry

    @Binding var runningTimer: TimeEntry?
    @Binding var timer: Timer?

    @State private var isEditingEntry: Bool = false

    private var isRunningEntry: Bool {
        entry == store.allEntries.first && entry.endDate == Date.distantFuture
    }

    private var formattedEndTime: String {
        if isRunningEntry {
            return Date().timeFormatted
        } else {
            return entry.endDate.timeFormatted
        }
    }

    var body: some View {
        HStack {
            VStack {
                Text("\(entry.startDate.fullDateFormatted) \(entry.startDate.timeFormatted) - \(formattedEndTime)")
                if entry.tag != nil {
                    Text("\(Image(systemName: "tag")) \(entry.tag!.rawValue)")
                        .font(.callout)
                }
            }
            Spacer()

            Group {
                Button {
                    isEditingEntry = true
                } label: {
                    Image(systemName: "pencil")
                }
                .sheet(isPresented: $isEditingEntry, onDismiss: nil) {
                    EditTimeEntryView(entry: entry)
                        .environmentObject(store)
                }

                if !isRunningEntry {
                    Button {
                        store.remove(entry)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .background(isRunningEntry ? Color.orange : Color.clear)
    }
}

struct EntryRowView_Previews: PreviewProvider {
    static var previews: some View {
        EntryRowView(
            entry: TimeEntry(startDate: Date(timeIntervalSinceNow: -20000), endDate: Date.distantFuture, tag: .work),
            runningTimer: .constant(nil),
            timer: .constant(nil)
        )
        .environmentObject(Store())
        .padding()
    }
}
