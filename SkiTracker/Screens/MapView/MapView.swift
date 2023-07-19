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
    map.region = MKCoordinateRegion(center: viewModel.route.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
    map.userTrackingMode = .follow
    map.showsUserLocation = true
    map.delegate = context.coordinator
    return map
  }

  func updateUIView(_ uiView: MKMapView, context: Self.Context) {
    uiView.addOverlay(viewModel.route, level: .aboveLabels)
    uiView.setRegion(MKCoordinateRegion(center: viewModel.route.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
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
