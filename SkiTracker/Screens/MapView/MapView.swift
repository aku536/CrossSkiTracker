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

  private let map = MyMapView()

  var body: some View {
    map
      .onReceive(viewModel.$locations, perform: { kek in
        map.addOverlay(viewModel.makePolyline())
      })
      .edgesIgnoringSafeArea(.all)
  }
}

struct MyMapView: UIViewRepresentable {

  let delegate = MapDelegate()
  private let map = MKMapView()

  func makeUIView(context: Context) -> MKMapView {
    map.region = MKCoordinateRegion(center: .init(latitude: 55.583957, longitude: 37.543354), latitudinalMeters: 10000, longitudinalMeters: 10000)
    map.userTrackingMode = .followWithHeading
    map.delegate = delegate
    return map
  }

  func updateUIView(_ uiView: MKMapView, context: Self.Context) {
    uiView.setNeedsDisplay()
  }

  @discardableResult
  func addOverlay(_ overlay: MKOverlay) -> some View {
    map.addOverlay(overlay, level: .aboveLabels)
    return self
  }
}
