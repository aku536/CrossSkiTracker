//
//  MapViewModel.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 20.03.2023.
//

import Combine
import Foundation
import MapKit

final class MapViewModel: ObservableObject, Identifiable {

  @Published var region = MKCoordinateRegion()

  func makePolyline() -> MKPolyline {
    let coordinates = locations.map { $0.coordinate }
    return MKPolyline(coordinates: coordinates, count: coordinates.count)
  }

  init(locations: [CLLocation]) {
    self.locations = locations
  }

  private let locations: [CLLocation]
}

final class MapDelegate: NSObject, MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .blue
    renderer.lineWidth = 5
    return renderer
  }
}
