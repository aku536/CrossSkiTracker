//
//  MainViewModel.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject, Identifiable {

  @Published var date = Date()
  @Published var distance = Measurement(value: 0, unit: UnitLength.kilometers)

  private var timer: Timer?
  private var startTime = Date()

  private let locationService = LocationService()

  lazy var newTimer = Timer.publish(every: 1, tolerance: 0.1, on: .current, in: .common).autoconnect()
    .sink { [weak self] _ in
      guard let self else { return }
      self.date = Date(timeInterval: 0, since: self.startTime)
      self.distance.value = self.locationService.getDistance() / 1000
    }

  private var disposables = Set<AnyCancellable>()

  init() {
    newTimer.store(in: &disposables)
  }
}
