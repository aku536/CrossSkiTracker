//
//  MapViewModel.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 20.03.2023.
//

import Combine
import Foundation
import MapKit

@MainActor
final class MapViewModel: ObservableObject, Identifiable {

  @Published var route: MKPolyline = MKPolyline()

  init(locationService: LocationService) {
    self.locationService = locationService
    locationService.$route
      .sink { [weak self] locations in
        let coordinates = locations.map { $0.coordinate }
        self?.route = MKPolyline(coordinates: coordinates, count: coordinates.count)
      }
      .store(in: &cancellable)
  }

  private let locationService: LocationService
  private var cancellable: Set<AnyCancellable> = []
}
