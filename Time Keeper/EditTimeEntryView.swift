//
//  EditTimeEntryView.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 12/7/21.
//

import SwiftUI

struct EditTimeEntryView: View {

    let entry: TimeEntry

    @Environment(\.presentationMode) var presentation
    @EnvironmentObject private var store: Store

    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    var body: some View {
        VStack {
            Text("Edit Time Entry")

            Spacer()

            Text("""
            Time Entry
            Started: \(entry.startDate.fullDateTimeFormatted)
            Ended:   \(entry.endDate.fullDateTimeFormatted)
            """)

            Spacer()

            HStack {
                DatePicker("Start Date", selection: $startDate)
            }
            HStack {
                DatePicker("End Date", selection: $endDate)
            }

            HStack {
                Button("Cancel") {
                    presentation.wrappedValue.dismiss()
                }
                Button("Save") {
                    store.edit(entry, newStartDate: startDate, newEndDate: endDate)
                    presentation.wrappedValue.dismiss()
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            startDate = entry.startDate
            endDate = entry.endDate
        }
    }
}

struct EditTimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        EditTimeEntryView(entry: TimeEntry(
            startDate: Date(timeIntervalSinceNow: -50000),
            endDate: Date(),
            tag: .work
        ))
        .environmentObject(Store())
    }
}
