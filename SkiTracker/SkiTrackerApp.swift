//
//  SkiTrackerApp.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import SwiftUI

@main
@MainActor
struct SkiTrackerApp: App {

  var body: some Scene {
    WindowGroup {
      MainView().environment(\.locale, Locale(identifier: "ru_RU"))
        .environmentObject(mainViewModel)
        .environmentObject(trainingsListViewModel)
    }
  }

  private let locationService = LocationService()
  private let storageService = StorageService()

  private var mainViewModel: MainViewModel {
    let mainViewModel = MainViewModel(trainingModel: TrainingModel(),
                                      locationService: locationService,
                                      storageService: storageService)
    return mainViewModel
  }

  private var trainingsListViewModel: TrainingsListViewModel {
    TrainingsListViewModel(storageService: storageService)
  }
}
