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

  @Published var locations: [CLLocation] = []

  func makePolyline() -> MKPolyline {
    let coordinates = locations.map { $0.coordinate }
    return MKPolyline(coordinates: coordinates, count: coordinates.count)
  }

  init(locationService: LocationService) {
    self.locationService = locationService
    locationService.$route
      .assign(to: \.locations, on: self)
      .store(in: &cancellable)
  }

  private let locationService: LocationService
  private var cancellable: Set<AnyCancellable> = []
}

final class MapDelegate: NSObject, MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .blue
    renderer.lineWidth = 5
    return renderer
  }

}
