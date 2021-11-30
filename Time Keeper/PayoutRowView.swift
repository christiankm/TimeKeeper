//
//  PayoutRowView.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 12/7/21.
//

import SwiftUI

struct PayoutRowView: View {

    @EnvironmentObject private var store: Store

    let payout: Payout

    var body: some View {
        HStack {
            Text("\(payout.date.fullDateFormatted)")
            Text("Days: \(String(format: "%0.2f", payout.days.rawValue))")

            Spacer()

            Group {
                Button {
                    store.remove(payout)
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

struct PayoutRowView_Previews: PreviewProvider {
    static var previews: some View {
        PayoutRowView(payout: Payout(date: Date(), days: .threeQuarters))
            .environmentObject(Store())
            .padding()
    }
}
