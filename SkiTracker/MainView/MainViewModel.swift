//
//  MainViewModel.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import Combine
import Foundation

// MARK: - MainViewModel

final class MainViewModel: ObservableObject, Identifiable {

  // MARK: - ViewModel

  @Published var date = Date()
  @Published var distance = Measurement(value: 0, unit: UnitLength.kilometers)
  @Published var elevation = Measurement(value: 0, unit: UnitLength.meters)
  @Published var maxSpeed = Measurement(value: 0, unit: UnitSpeed.kilometersPerHour)

  @Published var inProgress = false {
    didSet {
      if inProgress {
        startTime = Date()
        timer = makeTimer()
        Task { await locationService.startLocating() }
      } else {
        timer?.cancel()
        locationService.stopLocating()
        date = Date()
      }
    }
  }

  func didTapMapOpen() -> MapView {
    let locations = locationService.getRoute()
    let viewModel = MapViewModel(locations: locations)
    return MapView(viewModel: viewModel)
  }

  // MARK: - Private

  private var startTime = Date()
  private var isTracking = false

  private let locationService = LocationService()

  private var timer: AnyCancellable?

  private func makeTimer() -> AnyCancellable  {
    Timer.publish(every: 1, tolerance: 0.1, on: .current, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self, inProgress else { return }
        self.date = Date(timeInterval: 0, since: self.startTime)
        self.distance.value = self.locationService.getDistance() / 1000
        self.elevation.value = self.locationService.elevation
        self.maxSpeed.value = self.locationService.maxSpeed
      }
  }
}
