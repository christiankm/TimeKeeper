//
//  TimeKeeperApp.swift
//  Time Keeper
//
//  Created by Christian Mitteldorf on 5/7/21.
//

import SwiftUI

@main
struct TimeKeeperApp: App {

    @ObservedObject private var store = Store()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
