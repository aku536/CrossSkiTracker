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

  func didTapLocation() {
    if isTracking {
      locationService.stopLocating()
    } else {
      Task { await locationService.startLocating() }
    }
    isTracking.toggle()
  }

  func didTapMapOpen() -> MapView {
    let locations = locationService.getRoute()
    let viewModel = MapViewModel(locations: locations)
    return MapView(viewModel: viewModel)
  }

  // MARK: - Init

  init() {
    newTimer.store(in: &disposables)
  }

  // MARK: - Private

  private var timer: Timer?
  private var startTime = Date()
  private var isTracking = false
  private var disposables = Set<AnyCancellable>()

  private let locationService = LocationService()

  private lazy var newTimer = Timer.publish(every: 1, tolerance: 0.1, on: .current, in: .common).autoconnect()
    .sink { [weak self] _ in
      guard let self else { return }
      self.date = Date(timeInterval: 0, since: self.startTime)
      self.distance.value = self.locationService.getDistance() / 1000
    }
}
