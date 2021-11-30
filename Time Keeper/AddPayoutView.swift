//
//  AddPayoutView.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 12/7/21.
//

import SwiftUI

struct AddPayoutView: View {

    @Environment(\.presentationMode) var presentation
    @EnvironmentObject private var store: Store

    @State private var date: Date = Date()
    @State private var days: Double = Payout.Days.full.rawValue

    var body: some View {
        VStack {
            Text("Add Payout")

            Spacer()

            HStack {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            HStack {
                Picker("Days", selection: $days) {
                    ForEach(Payout.Days.allCases) { day in
                        Text("\(String(format: "%0.2f", day.rawValue))")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            HStack {
                Button("Cancel") {
                    presentation.wrappedValue.dismiss()
                }
                Button("Add") {
                    let payout = Payout(date: date, days: Payout.Days(rawValue: days)!)
                    store.add(payout)
                    presentation.wrappedValue.dismiss()
                }
            }

            Spacer()
        }
        .padding()
    }
}

struct AddPayoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddPayoutView()
            .environmentObject(Store())
    }
}
