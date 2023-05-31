//
//  LocationService.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import CoreLocation
import Foundation

final class LocationService: NSObject {

  @Published var route: [CLLocation] = []

  var startLocation: CLLocation? {
    route.first
  }

  var previousLocation: CLLocation? {
    route.last
  }

  var traveledDistance: Double {
    route.indices.reduce(into: 0) { result, index in
      guard index < route.count - 1 else { return }
      result += route[index + 1].distance(from: route[index])
    } / 1000
  }

  var elevation: CLLocationDistance {
    guard !route.isEmpty else { return 0 }
    let sortedByAltitude = route.sorted(by: { $0.altitude > $1.altitude })
    return sortedByAltitude.first!.altitude - sortedByAltitude.last!.altitude
  }

  var maxSpeed: CLLocationSpeed {
    let maxSpeed = route.max { $0.speed < $1.speed }?.speed ?? 0
    return max(0, maxSpeed) * 3.6
  }

  func startLocating() async {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.allowsBackgroundLocationUpdates = true
      locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()

    }
  }

  func stopLocating() {
    locationManager.stopUpdatingLocation()
    route = []
  }

  private let locationManager = CLLocationManager()
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    route += locations
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if (error as? CLError)?.code == .denied {
      manager.stopUpdatingLocation()
    }
  }
}
