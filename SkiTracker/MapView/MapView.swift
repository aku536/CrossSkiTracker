//
//  MapView.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 18.03.2023.
//

import MapKit
import SwiftUI

struct MapView: View {

  @State private var region = MKCoordinateRegion()
  @State private var trackingMode: MapUserTrackingMode = .follow

  var body: some View {
    Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $trackingMode)
      .edgesIgnoringSafeArea(.all)
  }
}
