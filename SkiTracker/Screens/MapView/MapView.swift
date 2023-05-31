//
//  MapView.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 18.03.2023.
//

import Combine
import MapKit
import SwiftUI

struct MapView: View {

  @ObservedObject var viewModel: MapViewModel

  var body: some View {
    MyMapView(viewModel: viewModel)
      .edgesIgnoringSafeArea(.all)
  }
}

struct MyMapView: UIViewRepresentable {

  @ObservedObject var viewModel: MapViewModel

  func makeCoordinator() -> MapDelegate {
    MapDelegate()
  }

  func makeUIView(context: Context) -> MKMapView {
    let map = MKMapView()
    map.region = MKCoordinateRegion(center: .init(latitude: 55.583957, longitude: 37.543354), latitudinalMeters: 10000, longitudinalMeters: 10000)
    map.userTrackingMode = .followWithHeading
    map.delegate = context.coordinator
    return map
  }

  func updateUIView(_ uiView: MKMapView, context: Self.Context) {
    uiView.addOverlay(viewModel.route, level: .aboveLabels)
  }

  final class MapDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer(overlay: overlay)
      renderer.strokeColor = .blue
      renderer.lineWidth = 5
      return renderer
    }
  }
}
