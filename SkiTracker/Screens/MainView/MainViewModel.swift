//
//  MainViewModel.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import Combine
import Foundation
import SwiftUI

// MARK: - MainViewModel

@MainActor
final class MainViewModel: ObservableObject, Identifiable {

  // MARK: - Models

  @Published var trainingTime = Date()

  @Published var trainingModel: TrainingModel

  var inProgress = false {
    didSet {
      if inProgress {
        startTime = Date()
        timer = makeTimer()
        Task { await locationService.startLocating() }
      } else {
        timer?.cancel()
        locationService.stopLocating()
        trainingModel.trainingTime = 0
      }
    }
  }

  func didTapMapOpen() -> MapView {
    let viewModel = MapViewModel(locationService: locationService)
    return MapView(viewModel: viewModel)
  }

  // MARK: - Init

  init(trainingModel: TrainingModel, locationService: LocationService) {
    self.trainingModel = trainingModel
    self.locationService = locationService
  }

  // MARK: - Private

  private var startTime = Date()

  private let locationService: LocationService

  private var timer: AnyCancellable?

  private func makeTimer() -> AnyCancellable  {
    Timer.publish(every: 1, tolerance: 0.1, on: .current, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self, inProgress else { return }
        self.updateModel()
      }
  }
}

private extension MainViewModel {
  func updateModel() {
    trainingModel.trainingTime = Date().timeIntervalSince(startTime)
    trainingTime = Date(timeInterval: 0, since: startTime)
    trainingModel.distance = locationService.traveledDistance
    trainingModel.elevation = locationService.elevation
    trainingModel.maxSpeed = locationService.maxSpeed
  }
}
