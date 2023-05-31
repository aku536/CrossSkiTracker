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

  enum State {
    case notRunning
    case active
    case finished

    mutating func toggle() {
      switch self {
      case .notRunning:
        self = .active
      case .active:
        self = .finished
      case .finished:
        self = .notRunning
      }
    }
  }

  // MARK: - Models

  @Published var trainingTime = Date()
  @Published var trainingModel: TrainingModel

  @Published var state: State = .notRunning {
    didSet {
      switch state {
      case .notRunning:
        trainingModel.trainingTime = 0
      case .active:
        startTime = Date()
        timer = makeTimer()
        Task { await locationService.startLocating() }
      case .finished:
        timer?.cancel()
        locationService.stopLocating()
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
        guard let self, state == .active else { return }
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
