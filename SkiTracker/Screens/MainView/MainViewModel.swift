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
        timer = nil
        locationService.stopLocating()
      }
    }
  }

  @Published var savedTrainings: [TrainingModel] = []

  func loadTrainings() async {
    savedTrainings = storageService.loadTrainings()
  }

  func saveTraining() {
    storageService.save(trainingModel)
    savedTrainings += [trainingModel]
  }

  func deleteTraining(with id: UUID) {
    storageService.deleteTraining(with: id)
    savedTrainings.removeAll { $0.id == id }
  }

  func resetTraining() {
    trainingModel = TrainingModel()
  }

  func didTapMapOpen() -> MapView {
    let viewModel = MapViewModel(locationService: locationService)
    return MapView(viewModel: viewModel)
  }

  // MARK: - Init

  init(trainingModel: TrainingModel, locationService: LocationService, storageService: StorageService) {
    self.trainingModel = trainingModel
    self.locationService = locationService
    self.storageService = storageService

    Task {
//      await loadTrainings()
    }
  }

  // MARK: - Private

  private var startTime = Date()

  private let locationService: LocationService
  private let storageService: StorageService

  private var timer: AnyCancellable?

  private func makeTimer() -> AnyCancellable  {
    Timer.publish(every: 1, tolerance: 0.1, on: .current, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self, state == .active else { return }
        self.updateModel()
      }
  }

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
}

private extension MainViewModel {
  func updateModel() {
    trainingModel.trainingTime = Int(Date().timeIntervalSince(startTime))
    trainingTime = Date(timeInterval: 0, since: startTime)
    trainingModel.distance = locationService.traveledDistance
    trainingModel.elevation = locationService.elevation
    trainingModel.maxSpeed = locationService.maxSpeed
    trainingModel.date = startTime
  }
}
