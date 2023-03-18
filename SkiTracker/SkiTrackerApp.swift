//
//  SkiTrackerApp.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import SwiftUI

@main
struct SkiTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView().environment(\.locale, Locale(identifier: "ru_RU"))
        }
    }
}
